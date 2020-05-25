//
//  NewsItem.swift
//  HackerNewsClient
//
//  Created by Anton Gubarenko on 25.05.2020.
//  Copyright © 2020 Anton Gubarenko. All rights reserved.
//

import UIKit

struct NewsItem: Identifiable, Decodable, Hashable {
    let by: String
    let descendants: Int
    let id: Int
    let kids: [Int]?
    let score: Int
    let time: Double
    let title: String
    let type: String
    let url: String?
    
    init() {
        self.by = "Charles Dickens"
        self.title = "Christmas Stories"
        self.descendants = 0
        self.id = 0
        self.score = 0
        self.time = 0
        self.type = ""
        self.url = ""
        self.kids = []
    }
    
    var description: String {
        "\(title) by \(by)"
    }
}
