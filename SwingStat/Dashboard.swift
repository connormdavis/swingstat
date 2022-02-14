//
//  CircleImage.swift
//  SwingStat (iOS)
//
//  Created by Connor Davis on 2/14/22.
//

import SwiftUI
import AVKit

struct Dashboard: View {
    
    let avPlayer = AVPlayer(url: Bundle.main.url(forResource: "dustin", withExtension: "mov")!)
    
    var body: some View {
        VStack {
            VideoPlayer(player: avPlayer)
                .frame(width: 325, height: 335)
                .cornerRadius(25)

            Text("Welcome to SwingStat!")
                .font(.title)
                .fontWeight(.bold)
        }
        .padding()
        .navigationTitle("Dashboard")
    }
}

struct Dashboard_Previews: PreviewProvider {
    static var previews: some View {
        Dashboard()
    }
}
