//
//  Swing.swift
//  SwingStat (iOS)
//
//  Created by Connor Davis on 2/15/22.
//

import Foundation
import MLKitPoseDetectionAccurate
import AssetsLibrary
import AVFoundation


/*
 Ensures the given code is run on the main thread. Useful for calling from background task.
 */
func RunInMainThread(execute: @escaping ()->Void) {
    if Thread.isMainThread {
         execute()
    }
    else {
        DispatchQueue.main.async {
            execute()
        }
    }
}


class Swing: ObservableObject {
    @Published var video: URL?
    @Published var landmarksGenerated = false    // determines whether this swing's landmarks have been generated yet
    var landmarksText: String = "----"
    var landmarks: [Pose] = []
    
    // Swing video used for temp. testing
    let test_video = Bundle.main.url(forResource: "reg_swing", withExtension: "mov")
    
    init() {
        self.video = self.test_video
    }
    

    
    /*
     Generates the pose landmarks for the swing instance
     */
    func generateLandmarks(desiredFrames: [Int]) {
        DispatchQueue.global().async {
            let options = AccuratePoseDetectorOptions()
            options.detectorMode = .stream
            let poseDetector = PoseDetector.poseDetector(options: options)
            
            let asset = AVAsset(url: self.test_video!)
            let frames = VideoProcessing.extractFramesToVisionImages(from: asset, at: desiredFrames)
            

            var results: [Pose]?
            
            do {
                results = try poseDetector.results(in: frames[0])
            } catch let error {
                print("Failed to detect pose with error: \(error.localizedDescription).")
                return
            }
            guard let detectedPoses = results, !detectedPoses.isEmpty else {
                print("Pose detector returned no results.")
                return
            }
            
            print("Nose location (frame 1): \(detectedPoses[0].landmark(ofType: .nose).position)")
            
            var landmarksText = "Nose location: \(detectedPoses[0].landmark(ofType: .nose).position)\n"
            landmarksText += "Left toe location: \(detectedPoses[0].landmark(ofType: .leftToe).position)\n"
            landmarksText += "Right toe location: \(detectedPoses[0].landmark(ofType: .rightToe).position)\n"
            
            // Trigger UI updates on main thread
            DispatchQueue.main.async {
                self.landmarksText = landmarksText
                self.landmarks.append(detectedPoses[0])
                self.landmarksGenerated = true
            }
        }
        
        
        

//        print("Detected poses: \(detectedPoses)")
        
//        for i in stride(from: 0, to: numFrames, by: 100) {
//            var results: [Pose]?
//            do {
//                results = try poseDetector.results(in: frames[i])
//            } catch let error {
//                print("Failed to detect pose with error: \(error.localizedDescription).")
//                return
//            }
//            guard let detectedPoses = results, !detectedPoses.isEmpty else {
//                print("Pose detector returned no results.")
//                return
//            }
//            print("Detected poses: \(detectedPoses)")
//        }
        
//        print("# frames: \(frames.count)")
        
//        let poseDetector = PoseDetector.poseDetector(options: options)
        
    }
    
}
