//
//  VideoProcessing.swift
//  SwingStat (iOS)
//
//  Created by Connor Davis on 2/15/22.
//

import Foundation
import AssetsLibrary
import AVFoundation
import UIKit
import MLKit
import SwiftUI

class VideoProcessing {
    
    static private func convertCMSampleBufferToUIImage(buffer: CMSampleBuffer) -> UIImage {
        let imageBuffer = CMSampleBufferGetImageBuffer(buffer)!
        let ciimage = CIImage(cvPixelBuffer: imageBuffer)
        let image = self.convert(cmage: ciimage)
        return image
    }
    
    /*
     Converts CIImage to UIImage, for validating frame extraction below.
     */
    static private func convert(cmage: CIImage) -> UIImage {
        let context = CIContext(options: nil)
        let cgImage = context.createCGImage(cmage, from: cmage.extent)!
        let image = UIImage(cgImage: cgImage)
        
        return image
    }
    
    /*
     Returns the number of frames in an AVAsset holding a video
     */
    static func countFrames(in video: AVAsset) -> Int {
        let videoTrack = video.tracks(withMediaType: AVMediaType.video)[0]
        let fps = videoTrack.nominalFrameRate
        let duration = CMTimeGetSeconds(video.duration)
        let numFrames = Int(duration * Double(fps))
        return numFrames
//        let trackReaderOutput = AVAssetReaderTrackOutput(track: videoTrack, outputSettings: nil)
//
//        let reader = try! AVAssetReader(asset: video)
//
//        reader.add(trackReaderOutput)
//        reader.startReading()
//
//        var nFrames = 0
//        while let sampleBuffer = trackReaderOutput.copyNextSampleBuffer() {
//            let formatDescription = CMSampleBufferGetFormatDescription(sampleBuffer)
//            guard let format = formatDescription else {
//                print("Error: No CMFormatDescription for CMSampleBuffer.")
//                return -1
//            }
//            let mediaType = CMFormatDescriptionGetMediaType(format)
//            if mediaType == kCMMediaType_Video {
//                nFrames += 1
//            }
//        }
//        return nFrames
    }
    
    /*
     Returns the number of seconds in an AVAsset video/Users/connordavis/Desktop/Repos/SwingStat/SwingStat/Model/Swing.swift
     */
    static func getDuration(from video: AVAsset) -> Float64 {
        let duration = video.duration
        let durationTime = CMTimeGetSeconds(duration)
        return durationTime
    }
    
    /*
     Takes an AVAsset video and returns an array where each element is a single frame
     of the video stored as a 'VisionImage', the type required by ML Kit for detecting poses.
     */
    static func extractFramesAndGeneratePoseData(from video: AVAsset, at indices: [Int], forSwing swing: Swing) -> [Int: Pose] {
        let reader = try! AVAssetReader(asset: video)
        
        let videoTrack = video.tracks(withMediaType: AVMediaType.video)[0]
        
        let trackReaderOutput = AVAssetReaderTrackOutput(track: videoTrack, outputSettings: [String(kCVPixelBufferPixelFormatTypeKey): NSNumber(value: kCVPixelFormatType_32BGRA)])
        
        reader.add(trackReaderOutput)
        reader.startReading()
        
        // Config posture detector
        let options = AccuratePoseDetectorOptions()
        options.detectorMode = .stream
        let poseDetector = PoseDetector.poseDetector(options: options)
        
        // Will contain Pose representation of desired frames
        var poses: [Int: Pose] = [:]
        
        var frameCount = 0
        // getting frames ref: https://stackoverflow.com/questions/49390728/how-to-get-frames-from-a-local-video-file-in-swift/49394183c
        while let sampleBuffer = trackReaderOutput.copyNextSampleBuffer() {
//            print("sample at time \(CMSampleBufferGetPresentationTimeStamp(sampleBuffer))")
            
            // If no indices specified, extract all frames
            if indices.isEmpty || indices.contains(frameCount) {
                // Optionally save to camera roll for validation
//                let image = convertCMSampleBufferToUIImage(buffer: sampleBuffer)
//                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                
                // Create VisionImage and add to list
                let visionImage = VisionImage(buffer: sampleBuffer)
                
                // Generate pose data
                var results: [Pose]?
                do {
                    results = try poseDetector.results(in: visionImage)
                } catch let error {
                    print("Failed to detect pose with error: \(error.localizedDescription).")
                    // Trigger return to media picker on main thread
                    DispatchQueue.main.async {
                        swing.noPostureDetected = true
                    }
                    return [:]
                }
                guard let detectedPoses = results, !detectedPoses.isEmpty else {
                    print("Pose detector returned no results.")
                    // Trigger return to media picker on main thread
                    DispatchQueue.main.async {
                        swing.noPostureDetected = true
                    }
                    return [:]
                }
                
                // Extract first (and only) pose object
                let pose = detectedPoses[0]
                
                
                poses[frameCount] = pose
            }
            
            frameCount += 1
        }
        
        return poses
    }
    
    /*
     Returns the UIImage form of the given frame number
     */
    static func getFrameAsImage(frameNum: Int, url: URL) -> UIImage? {
        let avAsset = AVAsset(url: url)
        let reader = try! AVAssetReader(asset: avAsset)
        
        let videoTrack = avAsset.tracks(withMediaType: AVMediaType.video)[0]
        
        let trackReaderOutput = AVAssetReaderTrackOutput(track: videoTrack, outputSettings: [String(kCVPixelBufferPixelFormatTypeKey): NSNumber(value: kCVPixelFormatType_32BGRA)])
        
        reader.add(trackReaderOutput)
        reader.startReading()
        
        var frameCount = 0
        // getting frames ref: https://stackoverflow.com/questions/49390728/how-to-get-frames-from-a-local-video-file-in-swift/49394183c
        while let sampleBuffer = trackReaderOutput.copyNextSampleBuffer() {
//            print("sample at time \(CMSampleBufferGetPresentationTimeStamp(sampleBuffer))")
            
            // If no indices specified, extract all frames
            if frameCount == frameNum {
                // Optionally save to camera roll for validation
                let image = VideoProcessing.convertCMSampleBufferToUIImage(buffer: sampleBuffer)
                
                //UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                    
                return image
            }
            
            frameCount += 1
        }
        
        return nil
    }
    
    static func deleteVideo(at path: URL) {
        do {
             let fileManager = FileManager.default
            
            // Check if file exists
            if fileManager.fileExists(atPath: path.path) {
                // Delete file
                try fileManager.removeItem(atPath: path.path)
            } else {
                print("File does not exist")
            }
         
        }
        catch let error as NSError {
            print("An error took place: \(error)")
        }
    }
    
    
}


extension UIImage {
    func rotate(radians: Float) -> UIImage? {
        var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: CGFloat(radians))).size
        // Trim off the extremely small float value to prevent core graphics from rounding it up
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)

        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        let context = UIGraphicsGetCurrentContext()!

        // Move origin to middle
        context.translateBy(x: newSize.width/2, y: newSize.height/2)
        // Rotate around middle
        context.rotate(by: CGFloat(radians))
        // Draw the image at its center
        self.draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }
}
