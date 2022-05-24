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
    
    @StateObject var analyzerViewModel: SwingAnalyzerViewModel
    
    @State var swing: Swing = Swing(url: ContentView.stockUrl)
    
    @State var avPlayer: AVPlayer
    @State var setupFrame: Int?
    @State var backswingFrame: Int?
    @State var impactFrame: Int?
    
    @State var showAnalysis: Bool = false
    
    @State var analysisFailed = false
    
    // tracks when background processing began so no duplication happens
    @State var processing = false
    
    
    func framesSet() -> Bool {
        if (setupFrame != nil && backswingFrame != nil && impactFrame != nil) {
            // Trigger background processing of posture
            if !self.swing.processing {
                createSwingAndBeginAnalysis()
            }
            
            return true
        }
        return false
    }
    
    func createSwingAndBeginAnalysis() {
        swing.changeVideo(url: analyzerViewModel.videoUrl)
        
        let numFrames = VideoProcessing.countFrames(in: AVAsset(url: analyzerViewModel.videoUrl))

        // Save key moments
        swing.backswingFrame = backswingFrame!
        swing.setupFrame = setupFrame!
        swing.impactFrame = impactFrame!
        swing.totalFrames = numFrames
        
        swing.generateLandmarks(usingFrames: [])
        swing.generateImages()
    }
    
    private func getCurrentFrameNum() -> Int {
        let currentTime = avPlayer.currentTime().seconds
        let totalTime = avPlayer.currentItem!.duration.seconds
        let numFrames = VideoProcessing.countFrames(in: AVAsset(url: analyzerViewModel.videoUrl))
        
        print("Current time: \(currentTime)")
        
        let fps = Double(numFrames) / totalTime
        let chosenFrame = Int(ceil(fps * currentTime))
        print("FPS: \(fps)")
        print("Chosen frame: \(chosenFrame)")
        return chosenFrame
    }
    
    func setSetupTimestamp() {
        print("setup set")
        let num = getCurrentFrameNum()
        self.setupFrame = num
    }
    
    func setBackswingTimestamp() {
        print("backswing set")
        if self.setupFrame != nil {
            let num = getCurrentFrameNum()
            if setupFrame != num {
                self.backswingFrame = num
            }
        }
    }
    
    func setImpactTimestamp() {
        print("impact set")
        if self.setupFrame != nil && self.backswingFrame != nil {
            let num = getCurrentFrameNum()
            if setupFrame != num && backswingFrame != num {
                self.impactFrame = num
            }
        }
    }
    
    func analyze() {
        showAnalysis = true
    }
    

    
    var body: some View {
        NavigationLink(destination: SwingAnalysis(swing: swing, analysisFailed: $analysisFailed, previouslySavedSwing: false), isActive: $showAnalysis) { EmptyView() }
        VStack(alignment: .center) {
            Text("Select all three swing events:")
                .font(.system(size: 20))
                .fontWeight(.bold)
                .foregroundColor(Color.green)
            Text("Please choose the very top of the backswing")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(Color.gray)
            VideoPlayer(player: avPlayer)
//                .frame(width: 325, height: 335)
                .cornerRadius(25)
                .padding()
                .background(Color.white)
            
            Spacer()

            
            if framesSet() {
                Button(action: analyze) {
                    Text("Analyze 🔬")
                        .font(.headline)
                        .foregroundColor(Color.white)
                        .fontWeight(.bold)
                }
                .padding()
                    .background(Color.green)
                    .clipShape(Capsule())
            } else {
                HStack {
                    if self.setupFrame != nil {
                        Button(action: setSetupTimestamp) {
                            Text("Setup ✅")
                                .foregroundColor(Color.white)
                                .fontWeight(.bold)
                        }
                        .padding()
                        .background(Color.green)
                        .clipShape(Capsule())
                    } else {
                        Button(action: setSetupTimestamp) {
                            Text("Setup  ")
                                .foregroundColor(Color.white.opacity(0.8))
                                .fontWeight(.bold)
                        }
                        .padding()
                        .background(Color.green.opacity(0.35))
                        .clipShape(Capsule())

                    }
                    
                    if self.backswingFrame != nil {
                        Button(action: setBackswingTimestamp) {
                            Text("Backswing ✅")
                                .foregroundColor(Color.white)
                                .fontWeight(.bold)
                        }
                        .padding()
                        .background(Color.green)
                        .clipShape(Capsule())
                    } else {
                        Button(action: setBackswingTimestamp) {
                            Text("Backswing  ")
                                .foregroundColor(Color.white.opacity(0.8))
                                .fontWeight(.bold)
                        }
                        .padding()
                        .background(Color.green.opacity(0.35))
                        .clipShape(Capsule())

                    }
                    
                    if self.impactFrame != nil {
                        Button(action: setImpactTimestamp) {
                            Text("Impact ✅")
                                .foregroundColor(Color.white)
                                .fontWeight(.bold)
                        }
                        .padding()
                        .background(Color.green)
                        .clipShape(Capsule())
                    } else {
                        Button(action: setImpactTimestamp) {
                            Text("Impact  ")
                                .foregroundColor(Color.white.opacity(0.8))
                                .fontWeight(.bold)
                        }
                        .padding()
                        .background(Color.green.opacity(0.35))
                        .clipShape(Capsule())

                    }
                }
            }
            
        }
        .padding([.bottom], 20)
        .accentColor(Color.white)


        .onAppear {
            // If the analysis failed, return the user to the media picker
            if analysisFailed {
                dismiss()
            }
            avPlayer = AVPlayer(url: analyzerViewModel.videoUrl)
            // 1/8 speed -- 30FPS * 8 = 240FPS
            avPlayer.rate = 0.125
            
            // save the vid to documents directory
            SavedSwingVideoManager.saveSwingVideo(videoUrl: analyzerViewModel.videoUrl)
            print("changed video url to: \(analyzerViewModel.videoUrl)")
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
        SwingEventChooser(analyzerViewModel: SwingAnalyzerViewModel(), avPlayer: AVPlayer(url: ContentView.stockUrl))
    }
}
