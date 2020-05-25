//
//  NewsLoader.swift
//  HackerNewsClient
//
//  Created by Anton Gubarenko on 23.05.2020.
//  Copyright © 2020 Anton Gubarenko. All rights reserved.
//

import Foundation
import Combine

struct API {
    static let topNews = "https://hacker-news.firebaseio.com/v0/topstories.json?print=pretty"
    static let newNews = "https://hacker-news.firebaseio.com/v0/newstories.json?print=pretty"
    static let bestNews = "https://hacker-news.firebaseio.com/v0/beststories.json?print=pretty"
    static let item = "https://hacker-news.firebaseio.com/v0/item/%@.json?print=pretty"
}


class NewsLoader: ObservableObject {
    @Published
    var newsItems: [NewsItem] = []
    
    private var itemIDs: [Int] = []
    
    @Published
    var fetchProgress: Float = 0.0
    
    var itemsCount: Int {
        itemIDs.count
    }
    
    fileprivate let prefetchCount: Int = 50
    private(set) var currentPrefetchIndex = 0
    
    var haveItems: Bool {
        newsItems.count > 0
    }
    
    @Published
    var isLoading: Bool = false
    
    let newsType: NewsType
    
    init(newsType: NewsType) {
        self.newsType = newsType
    }
    
    
    private var cancellable: AnyCancellable?
    func loadNews() {
        isLoading = true
        var url: URL?
        switch newsType {
        case .latest:
            url = URL.init(string: API.newNews)!
            break
        case .top:
            url = URL.init(string: API.topNews)!
            break
        case .best:
            url = URL.init(string: API.bestNews)!
            break
        }
        guard let loadUrl = url else {
            self.isLoading = false
            return
        }
        self.cancellable = URLSession.shared.dataTaskPublisher(for: loadUrl)
        .map { $0.data }
        .decode(type: [Int].self, decoder: JSONDecoder())
        .receive(on: RunLoop.main)
        .sink(receiveCompletion: { completion in
            switch completion {
            case .failure(_):
                self.isLoading = false
                break
            case .finished:
                break
            }
        }) { itemID in
            self.itemIDs = itemID
            self.fetchNews()
        }
    }
    
    private func itemsPublisher(for itemIDs: [Int]) -> AnyPublisher<NewsItem, Error> {
        Publishers.Sequence(sequence: itemIDs.map { self.details(for: $0) })
            .flatMap(maxPublishers: .max(1)) { $0 }
            .eraseToAnyPublisher()
    }

    
     private func details(for id: Int) -> AnyPublisher<NewsItem, Error> {
        let url = URL(string: String.init(format: API.item, String(id)))!
        return URLSession.shared.dataTaskPublisher(for: url)
            .mapError { $0 as Error }
            .compactMap { $0.data }
            .compactMap { try? JSONDecoder().decode(NewsItem.self, from: $0) }
            .eraseToAnyPublisher()
    }
    
    private var newsRequests: AnyCancellable?
    func fetchNews() {
        self.isLoading = true
        
        let leftIndex = min(self.currentPrefetchIndex, self.itemIDs.count)
        let rightIndex = min(self.currentPrefetchIndex + self.prefetchCount, self.itemIDs.count)
        guard leftIndex < rightIndex else {
            self.isLoading = false
            return
        }
        print("Loading: \(leftIndex) - \(rightIndex) : \(self.newsType)")
        newsRequests = itemsPublisher(for: Array(self.itemIDs[leftIndex..<rightIndex]))
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
            self.isLoading = false
            switch completion {
            case .finished:
                print("done news")
                
            case .failure(let error):
                print("failed news", error)
            }
        }, receiveValue: { news in
            // do whatever you want with the images as they come in
            //print("\(self.newsItems.count + 1): \(news.title)")
            if !self.newsItems.contains(news) {
                self.newsItems.append(news)
                self.fetchProgress = Float(self.newsItems.count) / Float(self.itemsCount)
                self.currentPrefetchIndex += 1
            }
        })
    }
}
