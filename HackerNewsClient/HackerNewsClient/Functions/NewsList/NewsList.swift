//
//  NewsList.swift
//  HackerNewsClient
//
//  Created by Anton Gubarenko on 23.05.2020.
//  Copyright © 2020 Anton Gubarenko. All rights reserved.
//

import SwiftUI

enum NewsType {
    case latest, top, best
}

struct NewsList: View {
    
    @ObservedObject
    var newsLoader: NewsLoader
    
    
    init(newsLoader: NewsLoader) {
        self.newsLoader = newsLoader
        UITableView.appearance().showsVerticalScrollIndicator = false
    }
    
    var body: some View {
        VStack {
            ProgressView(progress: self.newsLoader.fetchProgress)
                
                .frame(height: 5.0)
            if newsLoader.newsItems.count > 0 {
                ZStack {
                    List(newsLoader.newsItems) { item in
                        NavigationLink.init(destination: NewsDetailView(newsItem: item), label:  {
                            RowItem(item: item)
                                .animation(.linear)
                                .onAppear {
                                    if item == self.newsLoader.newsItems.last &&  self.newsLoader.newsItems.count != self.newsLoader.itemsCount && !self.newsLoader.isLoading {
                                        print("Load more...")
                                        self.newsLoader.loadNews()
                                    }
                            }
                        })
                    }.disabled(newsLoader.isLoading)
                    
                    if newsLoader.isLoading {
                        LoadingView()
                    }
                }
            } else {
                if !newsLoader.isLoading {
                    Text("Sorry, no data")
                }
            }
            
            Spacer()
            
        }
        .onAppear {
            if !self.newsLoader.haveItems {
                self.newsLoader.loadNews()
            }
        }
    }
}

struct NewsList_Previews: PreviewProvider {
    static var previews: some View {
        NewsList(newsLoader: NewsLoader(newsType: .latest)).environment(\.locale, .init(identifier: "ru"))
    }
}
