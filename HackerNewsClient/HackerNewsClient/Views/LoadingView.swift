//
//  LoadingView.swift
//  HackerNewsClient
//
//  Created by Anton Gubarenko on 23.05.2020.
//  Copyright © 2020 Anton Gubarenko. All rights reserved.
//

import SwiftUI

struct LoadingView: View {
    
    var foreverAnimation: Animation {
        Animation.linear(duration: 3.0)
            .repeatForever(autoreverses: false)
    }
    @State var isActive = false
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .stroke(lineWidth: 7.0)
                    .opacity(0.3)
                    .foregroundColor(Color.red)
                    .frame(width: 50, height: 50)
                
                Circle()
                    .trim(from: 0.0, to: 0.3)
                    .stroke(style: StrokeStyle(lineWidth: 7.0, lineCap: .round, lineJoin: .round))
                    .foregroundColor(Color.red)
                    .rotationEffect(Angle(degrees: isActive ? 360.0 : 0.0))
                    .animation(self.foreverAnimation)
                    .frame(width: 50, height: 50)
            }
            Text("Loading...")
                .foregroundColor(Color.red)
                .font(.headline)
            }.padding()
            .background(Color.white)
            .cornerRadius(10.0)
            .onAppear {
                self.isActive = true
        }
    }
}


struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
       LoadingView()
    }
}
