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
    static private func countFrames(in video: AVAsset) -> Int {
        let videoTrack = video.tracks(withMediaType: AVMediaType.video)[0]
        let trackReaderOutput = AVAssetReaderTrackOutput(track: videoTrack, outputSettings: nil)
        
        let reader = try! AVAssetReader(asset: video)
        
        reader.add(trackReaderOutput)
        reader.startReading()
        
        var nFrames = 0
        while let sampleBuffer = trackReaderOutput.copyNextSampleBuffer() {
            let formatDescription = CMSampleBufferGetFormatDescription(sampleBuffer)
            guard let format = formatDescription else {
                print("Error: No CMFormatDescription for CMSampleBuffer.")
                return -1
            }
            let mediaType = CMFormatDescriptionGetMediaType(format)
            if mediaType == kCMMediaType_Video {
                nFrames += 1
            }
        }
        return nFrames
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
    static func extractFramesToVisionImages(from video: AVAsset, at indices: [Int]) -> [VisionImage] {
        let reader = try! AVAssetReader(asset: video)
        
        let videoTrack = video.tracks(withMediaType: AVMediaType.video)[0]
        
        let trackReaderOutput = AVAssetReaderTrackOutput(track: videoTrack, outputSettings: [String(kCVPixelBufferPixelFormatTypeKey): NSNumber(value: kCVPixelFormatType_32BGRA)])
        
        reader.add(trackReaderOutput)
        reader.startReading()
        
        // Will contain VisionImage representation of desired frames
        var frames: [VisionImage] = []
        
        var frameCount = 0
        // getting frames ref: https://stackoverflow.com/questions/49390728/how-to-get-frames-from-a-local-video-file-in-swift/49394183c
        while let sampleBuffer = trackReaderOutput.copyNextSampleBuffer() {
//            print("sample at time \(CMSampleBufferGetPresentationTimeStamp(sampleBuffer))")
            
            // Testing frame extraction
            if indices.contains(frameCount) {
                // Optionally save to camera roll for validation
                let image = convertCMSampleBufferToUIImage(buffer: sampleBuffer)
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                
                // Create VisionImage and add to list
                let visionImage = VisionImage(buffer: sampleBuffer)
                frames.append(visionImage)
            }
            
            frameCount += 1
        }
        
        return frames
    }
}
