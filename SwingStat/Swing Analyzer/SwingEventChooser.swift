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
    @Environment(\.dismiss) var dismiss
    
    @State var avPlayer: AVPlayer
    @State var swingVideo: URL
    @State var setupFrame: Int?
    @State var backswingFrame: Int?
    @State var impactFrame: Int?
    
    @State var analysisFailed = false
    
    func framesSet() -> Bool {
        if (setupFrame != nil && backswingFrame != nil && impactFrame != nil) {
            return true
        }
        return false
    }
    
    func createSwingAndBeginAnalysis() -> Swing {
        let swing = Swing(url: swingVideo)
        // Save key moments
        swing.backswingFrame = backswingFrame!
        swing.setupFrame = setupFrame!
        swing.impactFrame = impactFrame!
        
        swing.generateLandmarks(usingFrames: [])
        swing.generateImages()
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
        if self.setupFrame != nil {
            let num = getCurrentFrameNum()
            if setupFrame != num {
                self.backswingFrame = num
            }
        }
    }
    
    func setImpactTimestamp() {
        if self.setupFrame != nil && self.backswingFrame != nil {
            let num = getCurrentFrameNum()
            if setupFrame != num && backswingFrame != num {
                self.impactFrame = num
            }
        }
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
                .background(Color.green)
                .clipShape(Capsule())
                
                Button(action: setBackswingTimestamp) {
                    if self.backswingFrame != nil {
                        Text("Backswing ✅")
                    } else {
                        Text("Backswing   ")
                    }
                }
                .padding()
                .background(Color.green)
                .clipShape(Capsule())
                
                Button(action: setImpactTimestamp) {
                    if self.impactFrame != nil {
                        Text("Impact ✅")
                    } else {
                        Text("Impact   ")
                    }
                }
                .padding()
                .background(Color.green)
                .clipShape(Capsule())
            }
            .padding()
            
            if framesSet() {
                Spacer()
                NavigationLink {
                    SwingAnalysis(swing: createSwingAndBeginAnalysis(), analysisFailed: $analysisFailed)
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
        .accentColor(Color.white)


        .onAppear {
            // If the analysis failed, return the user to the media picker
            if analysisFailed {
                dismiss()
            }
        }
        .onDisappear() {
            self.setupFrame = nil
            self.impactFrame = nil
            self.backswingFrame = nil
        }
    }
}

struct SwingEventChooser_Previews: PreviewProvider {
    static var previews: some View {
        SwingEventChooser(avPlayer: AVPlayer(url: ContentView.stockUrl), swingVideo: ContentView.stockUrl)
    }
}
