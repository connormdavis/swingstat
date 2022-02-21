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


class Swing: ObservableObject {
    @Published var video: URL?
    @Published var landmarksGenerated = false    // determines whether this swing's landmarks have been generated yet
    @Published var processing = false            // 'true' when the landmarks are in the process of being generated
    var landmarksText: String = ""
    var landmarks: [Int: Pose] = [:]
    
    // Swing video used for temp. testing
    let test_video = Bundle.main.url(forResource: "reg_swing", withExtension: "mov")
    
    init() {
        self.video = self.test_video
    }
    

    
    /*
     Generates the pose landmarks for the swing instance
     */
    func generateLandmarks(desiredFrames: [Int]) {
        self.processing = true      // used for activity indicator
        
        DispatchQueue.global().async {
            let options = AccuratePoseDetectorOptions()
            options.detectorMode = .stream
            let poseDetector = PoseDetector.poseDetector(options: options)
            
            let asset = AVAsset(url: self.test_video!)
            let frames = VideoProcessing.extractFramesToVisionImages(from: asset, at: desiredFrames)
            

            var poses: [Int: Pose] = [:]
            var poseText = ""
            
            var results: [Pose]?
            for frameNum in desiredFrames {
                do {
                    guard let visionImgFrame = frames[frameNum] else {
                        print("Couldn't find frame #\(frameNum) in extracted frames dictionary.")
                        return
                    }
                    results = try poseDetector.results(in: visionImgFrame)
                } catch let error {
                    print("Failed to detect pose with error: \(error.localizedDescription).")
                    return
                }
                guard let detectedPoses = results, !detectedPoses.isEmpty else {
                    print("Pose detector returned no results.")
                    return
                }
                
                // Extract first (and only) pose object
                let pose = detectedPoses[0]
                poses[frameNum] = pose
                
                // Assemble text for display
                poseText += "Nose [\(frameNum)]: \(detectedPoses[0].landmark(ofType: .nose).position)\n"
            }
            
//            landmarksText += "Left thumb location: \(detectedPoses[0].landmark(ofType: .leftThumb).position)\n"
//            landmarksText += "Right thumb location: \(detectedPoses[0].landmark(ofType: .rightThumb).position)\n"
//            landmarksText += "Left toe location: \(detectedPoses[0].landmark(ofType: .leftToe).position)\n"
//            landmarksText += "Right toe location: \(detectedPoses[0].landmark(ofType: .rightToe).position)\n"
            
            // Trigger UI updates on main thread
            DispatchQueue.main.async {
                self.landmarksText = poseText
                self.landmarks = poses
                self.landmarksGenerated = true
                
                self.processing = false     // stop activity indicator
            }
        }
        
    }
    
}
