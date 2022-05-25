//
//  VideoAnalyzer.swift
//  SwingStat (iOS)
//
//  Created by Connor Davis on 4/26/22.
//

import SwiftUI
import AVFoundation
import AVKit

struct VideoAnalyzer: View {
    @State var avPlayer: AVPlayer
    @State var currentPlaybackRate: Float = 1.0
    @State var isPlaying = false
    
    func toggleSpeed() {
        if currentPlaybackRate == 1.0 {
            currentPlaybackRate = 0.25
        } else {
            currentPlaybackRate = 1.0
        }
        // Update the player
        avPlayer.rate = currentPlaybackRate
    }
    
    var body: some View {
        VStack {
            Button(action: toggleSpeed) {
                Text("Playback speed: \(currentPlaybackRate == 1.0 ? "🐇" : "🐢")")
                    .foregroundColor(Color.white)
                    .font(.system(size: 20))
                    .fontWeight(.bold)
            }
            .padding()
            .background(Color.green)
            .clipShape(Capsule())
            
            VideoPlayer(player: avPlayer)
                .padding()
        }
        .padding()
    }
}

struct VideoAnalyzer_Previews: PreviewProvider {
    static let stockPlayer = AVPlayer(url: ContentView.stockUrl)
    static var previews: some View {
        VideoAnalyzer(avPlayer: stockPlayer)
    }
}
