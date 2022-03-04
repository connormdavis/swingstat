//
//  SwingEventChooser.swift
//  SwingStat (iOS)
//
//  Created by Connor Davis on 3/2/22.
//

import SwiftUI
import AVKit

struct SwingEventChooser: View {
    @Environment(\.colorScheme) var colorScheme
    
    @State var avPlayer: AVPlayer
    @State var swingVideo: URL
    @State var setupFrame: Int?
    @State var backswingFrame: Int?
    @State var impactFrame: Int?
    
    func framesSet() -> Bool {
        if (setupFrame != nil && backswingFrame != nil && impactFrame != nil) {
            return true
        }
        return false
    }
    
    func createSwingAndBeginAnalysis() -> Swing {
        let swing = Swing(url: swingVideo)
        swing.generateLandmarks(usingFrames: [])
        return swing
    }
    
    private func getCurrentFrameNum() -> Int {
        let currentTime = avPlayer.currentTime().seconds
        let totalTime = avPlayer.currentItem!.duration.seconds
        let numFrames = VideoProcessing.countFrames(in: AVAsset(url: swingVideo))
        
        let fps = Double(numFrames) / totalTime
        let chosenFrame = Int(fps * currentTime)
        return chosenFrame
    }
    
    func setSetupTimestamp() {
        let num = getCurrentFrameNum()
        self.setupFrame = num
    }
    
    func setBackswingTimestamp() {
        let num = getCurrentFrameNum()
        self.backswingFrame = num
    }
    
    func setImpactTimestamp() {
        let num = getCurrentFrameNum()
        self.impactFrame = num
    }
    

    
    var body: some View {
        VStack(alignment: .center) {
            Text("Choose the 3 swing events:")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(Color.green)
            VideoPlayer(player: avPlayer)
                .frame(width: 325, height: 335)
                .cornerRadius(25)
                .padding()
            Spacer()
            HStack {
                Button(action: setSetupTimestamp) {
                    if self.setupFrame != nil {
                        Text("Setup ✅")
                    } else {
                        Text("Setup   ")
                    }
                }
                .padding()
                .background(colorScheme == .dark ? Color.white : Color.black)
                .clipShape(Capsule())
                
                Button(action: setBackswingTimestamp) {
                    if self.backswingFrame != nil {
                        Text("Backswing ✅")
                    } else {
                        Text("Backswing   ")
                    }
                }
                .padding()
                .background(colorScheme == .dark ? Color.white : Color.black)
                .clipShape(Capsule())
                
                Button(action: setImpactTimestamp) {
                    if self.impactFrame != nil {
                        Text("Impact ✅")
                    } else {
                        Text("Impact   ")
                    }
                }
                .padding()
                .background(colorScheme == .dark ? Color.white : Color.black)
                .clipShape(Capsule())
            }
            .padding()
            
            if framesSet() {
                Spacer()
                NavigationLink {
                    SwingAnalysis(swing: createSwingAndBeginAnalysis())
                } label: {
                    Text("Analyze")
                    .padding()
                    .foregroundColor(Color.white)
                    .background(Color.green)
                    .clipShape(Capsule())
                }
                Spacer()
            } else {
                Text("Select landmarks to perform analysis.")
                Spacer()
            }
            
        }
    }
}

struct SwingEventChooser_Previews: PreviewProvider {
    static var previews: some View {
        SwingEventChooser(avPlayer: AVPlayer(url: ContentView.stockUrl), swingVideo: ContentView.stockUrl)
    }
}
