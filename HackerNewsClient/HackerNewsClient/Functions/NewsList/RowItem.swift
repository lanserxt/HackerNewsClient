//
//  RowItem.swift
//  HackerNewsClient
//
//  Created by Anton Gubarenko on 25.05.2020.
//  Copyright © 2020 Anton Gubarenko. All rights reserved.
//

import SwiftUI

struct RowItem: View {
    
    init(item: NewsItem) {
        self.item = item
    }
    
    let item: NewsItem
    var body: some View {
        VStack(alignment: .leading){
            Text(item.title)
                .font(.headline)
                .padding(.bottom, 5.0)
            Text("by \(item.by)")
                .font(.subheadline)
            
        }
        .padding()
        .environment(\.defaultMinListRowHeight, 50)
    }
    
}
struct RowItem_Previews: PreviewProvider {
    static var previews: some View {
        RowItem(item: NewsItem())
    }
}
