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
import SwiftUI


class Swing: ObservableObject {
    
    let id: String
    let date: Date
    let thumbnail: Image
    
    @Published var video: URL?
    @Published var landmarksGenerated = false    // determines whether this swing's landmarks have been generated yet
    @Published var processing = false            // 'true' when the landmarks are in the process of being generated
    var landmarksText: String = ""
    var landmarks: [Int: Pose] = [:]
    
    // Frame no's for specific moments
    var setupFrame: Int = -1
    var backswingFrame: Int = -1
    var impactFrame: Int = -1
    var totalFrames: Int = -1
    
    
    init(url: URL?) {
        self.video = url
        self.id = UUID().uuidString
        self.date = Date()
        self.thumbnail = Image(systemName: "multiply.circle.fill")
    }
    
    /*
     Writes JSON to a given file URL
     */
    static func writePoseJsonToFile(fileUrl: URL, json: Data) {
        do {
            try json.write(to: fileUrl)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    /*
     Returns file name of the swing's video
     */
    func getFilename() -> String {
        guard let filename = self.video?.lastPathComponent else {
            print("Error: Swing doesn't have a URL.")
            return "--no video URL--"
        }
        return filename
    }

    /*
     Resets the state when an entirely new swing video is selected.
     */
    func changeVideo(url: URL) {
        self.video = url
        self.landmarksGenerated = false
        self.processing = false
        self.landmarksText = ""
        self.landmarks = [:]
    }
    
    /*
     Generates the pose landmarks for the swing instance
     */
    func generateLandmarks(usingFrames: [Int], increment: Int = 1) {
        self.processing = true      // used for activity indicator
        
        DispatchQueue.global().async {
            let options = AccuratePoseDetectorOptions()
            options.detectorMode = .stream
            let poseDetector = PoseDetector.poseDetector(options: options)
            
            let asset = AVAsset(url: self.video!)
            let frames = VideoProcessing.extractFramesToVisionImages(from: asset, at: usingFrames)
            
            // If no frames specified, create an array with all frames
            var desiredFrames: [Int] = []
            if usingFrames.isEmpty {
                for i in stride(from: 0, to: frames.count, by: increment) {
                    desiredFrames.append(i)
                }
            } else {
                desiredFrames = usingFrames
            }
            
            var poses: [Int: Pose] = [:]
            var poseText = ""

            var results: [Pose]?
            var count = 0
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
//                poseText += "Nose [\(frameNum)]: \(detectedPoses[0].landmark(ofType: .nose).position)\n"
                
                count += 1
                
                print(".nose raw value: \(detectedPoses[0].landmark(ofType: .nose).type.rawValue)")
                print("Frame \(frameNum) (#\(count)) - posture analyzed.")
            }
            
            if usingFrames.isEmpty {
                poseText = "\(count) total frames processed at increment \(increment).\n\n'swing.json' generated and ready to share."
            } else {
                poseText = "\(count) total frames processed. Specified frames: \(usingFrames)"
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
