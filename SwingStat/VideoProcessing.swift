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
     Returns the number of seconds in an AVAsset video
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
    static func extractFramesToVisionImages(from video: AVAsset, at indices: [Int]) -> [Int: VisionImage] {
        let reader = try! AVAssetReader(asset: video)
        
        let videoTrack = video.tracks(withMediaType: AVMediaType.video)[0]
        
        let trackReaderOutput = AVAssetReaderTrackOutput(track: videoTrack, outputSettings: [String(kCVPixelBufferPixelFormatTypeKey): NSNumber(value: kCVPixelFormatType_32BGRA)])
        
        reader.add(trackReaderOutput)
        reader.startReading()
        
        // Will contain VisionImage representation of desired frames
        var frames: [Int: VisionImage] = [:]
        
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
                frames[frameCount] = visionImage
            }
            
            frameCount += 1
        }
        
        return frames
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
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                    
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
