//
//  ProgressView.swift
//  HackerNewsClient
//
//  Created by Anton Gubarenko on 25.05.2020.
//  Copyright © 2020 Anton Gubarenko. All rights reserved.
//

import SwiftUI

struct ProgressView: View {
    let progress: Float
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                ZStack(alignment: .leading) {
                    Rectangle()
                        .background(Color.blue)
                        .frame(height: 5.0)
                        .opacity(0.1)
                    Rectangle()
                        .fill(Color.blue)
                        .frame(width: geometry.size.width * CGFloat(self.progress), height: 5.0)
                    Spacer()
                        .frame(width: 1.0)
                }.edgesIgnoringSafeArea(.all)
            }.edgesIgnoringSafeArea(.all)
        }
    }
}

struct ProgressView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressView(progress: 0.5)
    }
}
