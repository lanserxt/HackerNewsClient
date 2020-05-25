//
//  ContentView.swift
//  HackerNewsClient
//
//  Created by Anton Gubarenko on 23.05.2020.
//  Copyright © 2020 Anton Gubarenko. All rights reserved.
//

import SwiftUI

extension Binding {
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        return Binding(
            get: { self.wrappedValue },
            set: { selection in
                self.wrappedValue = selection
                handler(selection)
        })
    }
}

struct ContentView: View {
    @State private var selection = 0
    @State private var newsLoader = NewsLoader(newsType: .latest)
    
    var body: some View {
        NavigationView {
            VStack {
                Picker(selection: $selection.onChange(selectionChange(_:)), label: Text("")) {
                    Text("New").tag(0)
                    Text("Top").tag(1)
                    Text("Best").tag(2)
                }.pickerStyle(SegmentedPickerStyle())
                ZStack {
                    NewsList(newsLoader: newsLoader)
                }
            }
            .navigationBarTitle(Text("News"), displayMode: .inline)
        }
    }
    
    private func selectionChange(_ tag: Int) {
        switch tag {
        case 0:
            newsLoader = NewsLoader(newsType: .latest)
            break
        case 1:
            newsLoader = NewsLoader(newsType: .top)
            break
        default:
            newsLoader = NewsLoader(newsType: .best)
            break
        }
        newsLoader.loadNews()
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
