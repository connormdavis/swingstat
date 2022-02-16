//
//  CircleImage.swift
//  SwingStat (iOS)
//
//  Created by Connor Davis on 2/14/22.
//

import SwiftUI
import AVKit

struct Dashboard: View {
    @ObservedObject var swing: Swing
    
//    let updateLandmarkText = { (txt: String) in
//        landmarkText = txt
//    }
    
    let avPlayer = AVPlayer(url: Bundle.main.url(forResource: "reg_swing", withExtension: "mov")!)
    
    var body: some View {
        VStack(alignment: .center) {
            VideoPlayer(player: avPlayer)
                .frame(width: 325, height: 335)
                .cornerRadius(25)

            Text("Landmark data:")
                .font(.title)
                .fontWeight(.bold)
            
            TextEditor(text: $swing.landmarksText)
            
            Button("Generate landmarks") {
                swing.generateLandmarks(desiredFrames: [1, 100, 500, 1000])
            }
            
        }
        .padding()
        .navigationTitle("Dashboard")
    }
}

struct Dashboard_Previews: PreviewProvider {
    static let swing = Swing()
    
    static var previews: some View {
        Dashboard(swing: swing)
    }
}
