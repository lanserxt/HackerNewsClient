//
//  NewsDetailView.swift
//  HackerNewsClient
//
//  Created by Anton Gubarenko on 24.05.2020.
//  Copyright © 2020 Anton Gubarenko. All rights reserved.
//

import SwiftUI

struct NewsDetailView: View {
    let newsItem: NewsItem
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(newsItem.title)
                .font(.headline)
            Text("Author: \(newsItem.by)")
                .padding()
                .font(.subheadline)
            
            HStack {
                Text("Score: \(newsItem.score)")
                    .font(.body)
                Spacer()
                Text("Type: \(newsItem.type)")
                    .font(.body)
            }
            Spacer()
        }.padding()
    }
}

struct NewsDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NewsDetailView(newsItem: NewsItem())
    }
}
