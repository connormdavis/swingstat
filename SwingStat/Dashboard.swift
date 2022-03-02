//
//  CircleImage.swift
//  SwingStat (iOS)
//
//  Created by Connor Davis on 2/14/22.
//

import SwiftUI
import UIKit
import AVKit

struct Dashboard: View {
    @Environment(\.colorScheme) var colorScheme
    
    @ObservedObject var swing: Swing
    
    // Used for communicating to/from CameraView sheet
    @State var showCameraModal: Bool = false
    @State var selectedVideoUrl: URL = ContentView.stockUrl
    @State var newVideoMode: UIImagePickerController.SourceType = .camera
    
    @State var avPlayer = AVPlayer(url: Bundle.main.url(forResource: "reg_swing", withExtension: "mov")!)
    @State var setupFrameNum: Int?
    @State var backswingFrameNum: Int?
    @State var impactFrameNum: Int?
    
    @State var increment = "1"
    
    @FocusState private var changingIncrement: Bool


    
    private func getTotalFrames() -> Int {
        let numFrames = VideoProcessing.countFrames(in: AVAsset(url: swing.video!))
        return numFrames
    }
    
    private func getCurrentFrameNum() -> Int {
        let currentTime = avPlayer.currentTime().seconds
        let totalTime = avPlayer.currentItem!.duration.seconds
        let numFrames = VideoProcessing.countFrames(in: AVAsset(url: swing.video!))
        
        let fps = Double(numFrames) / totalTime
        let chosenFrame = Int(fps * currentTime)
        return chosenFrame
    }
    
    func setSetupTimestamp() {
        let num = getCurrentFrameNum()
        self.setupFrameNum = num
    }
    
    func setBackswingTimestamp() {
        let num = getCurrentFrameNum()
        self.backswingFrameNum = num
    }
    
    func setImpactTimestamp() {
        // REMOVE THIS LATER
        self.changingIncrement = false
        
        let num = getCurrentFrameNum()
        self.impactFrameNum = num
    }
    
    // Checks if user has set all three key moments
    func allTimestampsSet() -> Bool {
        if self.setupFrameNum != nil && self.backswingFrameNum != nil && self.impactFrameNum != nil {
            return true
        }
        return false
    }
    
    
    /*
     Action sheet for sharing the JSON
     */
    func actionSheet() {
        var serializedPoses: [Int: PoseSerializable] = [:]
        for (frameNum, pose) in swing.landmarks {
            let loadedPose = PoseSerializable.loadFromPose(pose: pose)
            serializedPoses[frameNum] = loadedPose  // added serializable pose to dict mapping frame -> pose
        }
        
        let totalFrames = getTotalFrames()
        let poseCollection = PoseCollectionSerializable(poses: serializedPoses, setupFrame: setupFrameNum!, backswingFrame: backswingFrameNum!, impactFrame: impactFrameNum!, totalFrames: totalFrames)
        
        let encoder = JSONEncoder()
        let poseJson = try! encoder.encode(poseCollection)
        
        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last {
            let fileUrl = documentsDirectory.appendingPathComponent("swing.json")
            
            Swing.writePoseJsonToFile(fileUrl: fileUrl, json: poseJson)
            
            let activityVC = UIActivityViewController(activityItems: [fileUrl], applicationActivities: nil)
            UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
        } else {
            print("Failed to load documents directory.")
            return
        }
    }

    
    var body: some View {
        VStack(alignment: .center) {
            HStack {
                Button("Record new video") {
                    newVideoMode = .camera
                    showCameraModal = true
                }
                    .padding()
                    .background(colorScheme == .dark ? Color.white : Color.black)
                    .clipShape(Capsule())
                Button("Choose new video") {
                    newVideoMode = .photoLibrary
                    showCameraModal = true
                }
                    .padding()
                    .background(colorScheme == .dark ? Color.white : Color.black)
                    .clipShape(Capsule())
            }
            
            VideoPlayer(player: avPlayer)
                .frame(width: 325, height: 335)
                .cornerRadius(25)
                .padding()
            
            HStack {
                Button(action: setSetupTimestamp) {
                    if self.setupFrameNum != nil {
                        Text("Setup ✅")
                    } else {
                        Text("Setup   ")
                    }
                }
                .padding()
                .background(colorScheme == .dark ? Color.white : Color.black)
                .clipShape(Capsule())
                Spacer()
                Button(action: setBackswingTimestamp) {
                    if self.backswingFrameNum != nil {
                        Text("Backswing ✅")
                    } else {
                        Text("Backswing   ")
                    }
                }
                .padding()
                .background(colorScheme == .dark ? Color.white : Color.black)
                .clipShape(Capsule())
                Spacer()
                Button(action: setImpactTimestamp) {
                    if self.impactFrameNum != nil {
                        Text("Impact ✅")
                    } else {
                        Text("Impact   ")
                    }
                }
                .padding()
                .background(colorScheme == .dark ? Color.white : Color.black)
                .clipShape(Capsule())
                
                TextEditor(text: $increment)
                    .frame(width: 20, height: 40)
                    .cornerRadius(8.0)
                    .focused($changingIncrement)
            }
            
            Spacer()
            Text("Landmark data:")
                .font(.title)
                .fontWeight(.bold)
            
            if swing.landmarksGenerated {
                TextEditor(text: .constant(swing.landmarksText))
            } else {
                if swing.processing {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                } else {
                    Text("No landmark data generated yet.")
                        .font(.body)
                        .foregroundColor(Color.gray)
                        .padding()
                }
            }
            
            Spacer()
            // If we haven't generated or aren't generating - show button (IF WE'VE SET TIMESTAMPS TOO)
            if !swing.landmarksGenerated && !swing.processing && allTimestampsSet() {
                Button("Generate landmarks") {
                    swing.generateLandmarks(usingFrames: [], increment: Int(increment)!)
                }
                .padding()
                .background(colorScheme == .dark ? Color.white : Color.black)
                .clipShape(Capsule())
            } else if swing.landmarksGenerated {
                HStack {
                    // Display button to view annotated video
                    Button("View posture annotations") {
                        print("Display video with posture annotations")
                    }
                    .padding()
                    .background(colorScheme == .dark ? Color.white : Color.black)
                    .clipShape(Capsule())
                    
                    Button(action: actionSheet) {
                        Image(systemName: "square.and.arrow.up")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 36, height: 36)
                    }
                }
                
            }
            
        }
        .onChange(of: selectedVideoUrl) { newUrl in
            avPlayer = AVPlayer(url: newUrl)    // Update viewer
            swing.changeVideo(url: newUrl)      // Change swing representation
        }
        .sheet(isPresented: $showCameraModal) {
            CameraView(mode: $newVideoMode, isPresented: $showCameraModal, videoUrl: $selectedVideoUrl)
        }
        .padding()
//        .navigationTitle("Dashboard")
        .navigationBarBackButtonHidden(true)
        
        
        
        
    }
}

struct Dashboard_Previews: PreviewProvider {
    static let URL = Bundle.main.url(forResource: "reg_swing", withExtension: "mov")!
    static let swing: Swing = Swing(url: Dashboard_Previews.URL)
    
    static var previews: some View {
        Dashboard(swing: swing)
    }
}
