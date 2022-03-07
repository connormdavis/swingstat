//
//  Swing.swift
//  SwingStat (iOS)
//
//  Created by Connor Davis on 2/15/22.
//

import Foundation
import MLKit
import AssetsLibrary
import AVFoundation
import SwiftUI
import UIKit


class Swing: ObservableObject {
    
    let id: String
    let date: Date
    let thumbnail: Image
    
    @Published var video: URL?
    @Published var landmarksGenerated = false    // determines whether this swing's landmarks have been generated yet
    @Published var processing = false            // 'true' when the landmarks are in the process of being generated
    @Published var noPostureDetected = false
    var landmarksText: String = ""
    var landmarks: [Int: Pose] = [:]
    
    // Frame no's for specific moments
    var setupFrame: Int = -1
    var backswingFrame: Int = -1
    var impactFrame: Int = -1
    var totalFrames: Int = -1
    
    @Published var setupImage: UIImage?
    @Published var backswingImage: UIImage?
    @Published var impactImage: UIImage?
    
    
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
     Deletes the video associated with a swing object
     */
    func delete() {
        VideoProcessing.deleteVideo(at: self.video!)
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
    
    func imagesGenerated() -> Bool {
        if setupImage != nil && backswingImage != nil && impactImage != nil {
            return true
        }
        return false
    }
    
    func analyzePostureInformation() async -> SwingTipResults? {
        while self.processing {
            // Wait here until we have our posture info
            Thread.sleep(forTimeInterval: 0.1)
        }
        
        do {
            let swingTipResults = try await self.fetchPostureAnalysis()
            return swingTipResults
        } catch {
            print("Request failed with error: \(error)")
            return nil
        }
    }
    
    private func fetchPostureAnalysis() async throws -> SwingTipResults? {
        guard let url = URL(string: "https://itunes.apple.com/search?term=taylor+swift&entity=album") else {
            print("Error requesting posture analysis.")
            return nil
        }

        // Use the async variant of URLSession to fetch data
        // Code might suspend here
        let (data, _) = try await URLSession.shared.data(from: url)

        // Parse the JSON data
        let swingTipResults = try JSONDecoder().decode(SwingTipResults.self, from: data)
        return swingTipResults
    }
    
    func generateImages() {
        DispatchQueue.global().async {
            let setupImage = VideoProcessing.getFrameAsImage(frameNum: self.setupFrame, url: self.video!)
            let backswingImage = VideoProcessing.getFrameAsImage(frameNum: self.backswingFrame, url: self.video!)
            let impactImage = VideoProcessing.getFrameAsImage(frameNum: self.impactFrame, url: self.video!)
            
            while self.processing {
                // Wait here until we have our posture info
                Thread.sleep(forTimeInterval: 0.1)
            }
        
            
            DispatchQueue.main.async {
                let setupImageAnnotated = Swing.createAnnotatedUIImage(image: setupImage!, pose: self.landmarks[self.setupFrame]!)
                let backswingImageAnnotated = Swing.createAnnotatedUIImage(image: backswingImage!, pose: self.landmarks[self.backswingFrame]!)
                let impactImageAnnotated = Swing.createAnnotatedUIImage(image: impactImage!, pose: self.landmarks[self.impactFrame]!)
                
                self.setupImage = setupImageAnnotated
                self.backswingImage = backswingImageAnnotated
                self.impactImage = impactImageAnnotated
            }
        }
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

            // Used to determine if there was a posture tracking issue to update on main thread
            var error = false
            
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
                    // Trigger return to media picker
                    self.noPostureDetected = true
                    return
                }
                guard let detectedPoses = results, !detectedPoses.isEmpty else {
                    print("Pose detector returned no results.")
                    // Trigger return to media picker
                    self.noPostureDetected = true
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

    
    static func createAnnotatedUIImage(image: UIImage, pose: Pose) -> UIImage {
        let imageView = self.createImageViewFromImage(image: image)
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        let annotationOverlayView = UIView(frame: .zero)
            annotationOverlayView.translatesAutoresizingMaskIntoConstraints = false
            annotationOverlayView.clipsToBounds = true
        imageView.addSubview(annotationOverlayView)
        NSLayoutConstraint.activate([
              annotationOverlayView.topAnchor.constraint(equalTo: imageView.topAnchor),
              annotationOverlayView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
              annotationOverlayView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
              annotationOverlayView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
        ])
        
        let transform = self.transformMatrix(image: image, imageView: imageView)
        let overlay = UIUtilities.createPoseOverlayView(forPose: pose, inViewWithBounds: imageView.bounds, lineWidth: 2.0, dotRadius: 5.0,
            positionTransformationClosure: { (position) -> CGPoint in
                return self.pointFrom(position).applying(transform)
            }
        )
        annotationOverlayView.addSubview(overlay)
        
        return self.createImageFromImageView(imageView: imageView, saveToPhotos: true)
        
//        for landmark in pose.landmarks {
//            let inFrameLikelihood = landmark.inFrameLikelihood
//
//            let point = self.pointFrom(landmark.position)
//            let transform = self.transformMatrix(image: image, imageView: imageView)
//            let transformedPoint = point.applying(transform)
//
//            UIUtilities.addCircle(
//                atPoint: transformedPoint,
//                to: annotationOverlayView,
//                color: UIColor.red,
//                radius: 7.0
//            )
//        }
//
//
//        return self.createImageFromImageView(imageView: imageView, saveToPhotos: true)
    }
    
    private static func createImageFromImageView(imageView: UIImageView, saveToPhotos: Bool = false) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: imageView.bounds.size)
        let image = renderer.image { ctx in
            let res = imageView.drawHierarchy(in: imageView.bounds, afterScreenUpdates: true)
            print("res: \(res)")
        }
        
        if saveToPhotos {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
        
        return image
    }
    
    
    private static func createImageViewFromImage(image: UIImage) -> UIImageView {
        let imageView = UIImageView()
        imageView.image = image
        
        let screenSize: CGRect = UIScreen.main.bounds
        let imageSize = CGSize(width: image.size.width, height: image.size.width)
        let screenRect = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
        let imageRect = AVMakeRect(aspectRatio: imageSize, insideRect: screenRect)
        imageView.frame = imageRect
        
        let renderer = UIGraphicsImageRenderer(size: imageView.bounds.size)
        let image = renderer.image { ctx in
            let res = imageView.drawHierarchy(in: imageView.bounds, afterScreenUpdates: true)
            print("res: \(res)")
        }
        
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    
        return imageView
        // use UIUtilities.addCircle() & shite to add subviews to the main 'imageView' and return it
    }
    
    private static func pointFrom(_ visionPoint: VisionPoint) -> CGPoint {
        return CGPoint(x: visionPoint.x, y: visionPoint.y)
      }
    
    private static func transformMatrix(image: UIImage, imageView: UIImageView) -> CGAffineTransform {
        guard let image = imageView.image else { return CGAffineTransform() }
        let imageViewWidth = imageView.frame.size.width
        let imageViewHeight = imageView.frame.size.height
        let imageWidth = image.size.width
        let imageHeight = image.size.height

        let imageViewAspectRatio = imageViewWidth / imageViewHeight
        let imageAspectRatio = imageWidth / imageHeight
        let scale =
          (imageViewAspectRatio > imageAspectRatio)
          ? imageViewHeight / imageHeight : imageViewWidth / imageWidth

        // Image view's `contentMode` is `scaleAspectFit`, which scales the image to fit the size of the
        // image view by maintaining the aspect ratio. Multiple by `scale` to get image's original size.
        let scaledImageWidth = imageWidth * scale
        let scaledImageHeight = imageHeight * scale
        let xValue = (imageViewWidth - scaledImageWidth) / CGFloat(2.0)
        let yValue = (imageViewHeight - scaledImageHeight) / CGFloat(2.0)

        var transform = CGAffineTransform.identity.translatedBy(x: xValue, y: yValue)
        transform = transform.scaledBy(x: scale, y: scale)
        return transform
      }
    
}
