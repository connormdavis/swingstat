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
import AVKit
import UIKit


class Swing: ObservableObject, Identifiable {
    
    let id: String
    let date: Date
    
    @Published var video: URL?
    @Published var landmarksGenerated = false    // determines whether this swing's landmarks have been generated yet
    @Published var processing = false            // 'true' when the landmarks are in the process of being generated
    @Published var analyzing = false
    
    // Indicates a previously saved swing is using
    @Published var regeneratingImages = false
    
    @Published var noPostureDetected = false
    @Published var swingTips: [SwingTip] = []
    
    
    var landmarksText: String = ""
    var landmarks: [Int: Pose] = [:]
    
    var savedSetupPose: PoseSerializable? = nil
    var savedBackswingPose: PoseSerializable? = nil
    var savedImpactPose: PoseSerializable? = nil
    
    // Frame no's for specific moments
    var setupFrame: Int = -1
    var backswingFrame: Int = -1
    var impactFrame: Int = -1
    var totalFrames: Int = -1
    var leftArmAngleFrame: Int = -1
    
    @Published var setupImage: UIImage?
    @Published var backswingImage: UIImage?
    @Published var impactImage: UIImage?
    
    
    // added after adding Tabler library for sorting
    var thumbnail: UIImage! = nil
    var filename: String! = nil
    var creationDate: Date! = nil         // based on metadata
    var videoDuration: Double! = nil
//    var swingScore: Double! = nil

    
    
    init(url: URL?, id: String = "") {
        self.video = url
        if id == "" {
            self.id = UUID().uuidString
        } else {
            self.id = id
        }
        
        self.date = Date()
        self.thumbnail = getThumbnailFrom(path: self.getVideoURL())
        
        // added after adding Tabler library for sorting
        self.filename = getFilename()
        self.creationDate = getDateCreatedFrom(path: self.getVideoURL())
        self.videoDuration = getDurationFrom(path: self.getVideoURL())
//        self.swingScore = getSwingScoreFrom(path: self.getVideoURL())
    }
    
    
    func filterSwings() -> SwingTipFiltered {
        var tempo = true
        var leftArm = true
        var hipSway = true
        var vertHead = true
        var latHead = true
                
        for tip in swingTips {
            if tip.type == "Swing tempo" {
                tempo = tip.passed
            }
            else if tip.type == "Left arm angle" {
                leftArm = tip.passed
            }
            else if tip.type == "Hip sway" {
                hipSway = tip.passed
            }
            else if tip.type == "Vertical head movement" {
                vertHead = tip.passed
            }
            else if tip.type == "Lateral head movement" {
                latHead = tip.passed
            }
        }
        
        let results = SwingTipFiltered(leftArmAngle: leftArm, lateralHeadMovement: latHead, verticalHeadMovement: vertHead, hipSway: hipSway, swingTempo: tempo)
        
        return results
    }
    
    
    // https://stackoverflow.com/questions/31779150/creating-thumbnail-from-local-video-in-swift
    /*
     Returns the thumbnail of a file given its URL
     */
    func getThumbnailFrom(path: URL) -> UIImage? {

        do {

            let asset = AVURLAsset(url: path , options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)

            return thumbnail

        } catch let error {

            print("*** Error generating thumbnail: \(error.localizedDescription)")
            return nil
        }
    }
    
    /*
     Returns the duration of a file given its URL
     */
    func getDurationFrom(path: URL) -> Double {
     
        let asset = AVAsset(url: path)

        let duration = asset.duration
        let durationTime = CMTimeGetSeconds(duration)
//        let durationTimeStr = String(format: "%.fs", durationTime)
        
        return durationTime
    }
    
    /*
     Returns the date a file was created given its URL (based on metadata)
     */
    func getDateCreatedFrom(path: URL) -> Date {
     
        let asset = AVAsset(url: path)

        let date = asset.creationDate
        let dateConverted = (date?.dateValue)!
        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "MM/dd/YY"
//        return dateFormatter.string(from: dateConverted)
        
        return dateConverted
        
    }
    

//    func getSwingScoreFrom(path: URL) -> Double {
//
//        let swingScore = self.swingTips
//        return swingScore
//    }

    // Converts the swing object to a serializable SavedSwingAnalysis for sending to backend
    func createSavableAnalysisItem(tips: [SwingTip]) -> SavedSwingAnalysis {
        var passedCount = 0
        for swingTip in tips {
            if swingTip.passed { passedCount += 1 }
        }
        
        var goodSwing = false
        if passedCount >= 3 {
            goodSwing = true
        }
        
        let setupFramePose = PoseSerializable.loadFromPose(pose: landmarks[setupFrame]!)
        let backswingFramePose = PoseSerializable.loadFromPose(pose: landmarks[backswingFrame]!)
        let impactFramePose = PoseSerializable.loadFromPose(pose: landmarks[impactFrame]!)
        
        // Save images to disc
        let setupImageName = "\(self.id)-setup.jpg"
        let backswingImageName = "\(self.id)-bacskwing.jpg"
        let impactImageName = "\(self.id)-impact.jpg"
        VideoProcessing.saveImage(imageName: setupImageName, image: setupImage!)
        VideoProcessing.saveImage(imageName: backswingImageName, image: backswingImage!)
        VideoProcessing.saveImage(imageName: impactImageName, image: impactImage!)
        
        
        
        let savedAnalysis = SavedSwingAnalysis(id: self.id, _id: self.id, videoName: self.getFilename(), swingTips: tips, goodSwing: goodSwing, setupFrame: setupFrame, setupImage: setupImageName, setupFramePose: setupFramePose, backswingFrame: backswingFrame, backswingImage: backswingImageName,  backswingFramePose: backswingFramePose, impactFrame: impactFrame, impactImage: impactImageName, impactFramePose: impactFramePose, leftArmAngleFrame: leftArmAngleFrame, totalFrames: totalFrames)
        
        return savedAnalysis
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
    func delete() async {
        // Remove associated swing analysis from backend
        var request = URLRequest(url: URL(string: "https://swingstat-backend.herokuapp.com/swing")!)
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            // Send request
            let (data, _) = try await URLSession.shared.data(for: request)
            print("Success deleting swing w/ ID \(self.id) from DB.")
//                        let swingTipResults = try JSONDecoder().decode(SwingTipResults.self, from: data)
        } catch {
            print("Error (couldn't delete saved swing analysis): \(error.localizedDescription)")
        }
        
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
     Returns the url of a swing video for use in generating thumbnail
     */
    func getVideoURL() -> URL {
        return video!
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
    
    func analyzePostureInformation() async -> [SwingTip] {
        while self.processing {
            // Wait here until we have our posture info
            do {
                try await Task.sleep(nanoseconds: 100000000)
            } catch {
                print("ERROR: \(error)")
                return []
            }
        }
        
        print("-> MARK: Requesting backend analysis!")
        
        var request = URLRequest(url: URL(string: "https://swingstat-backend.herokuapp.com/swing")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var serializedPoses: [Int: PoseSerializable] = [:]
        for (frameNum, pose) in self.landmarks {
            let loadedPose = PoseSerializable.loadFromPose(pose: pose)
            serializedPoses[frameNum] = loadedPose  // added serializable pose to dict mapping frame -> pose
        }
        
        let totalFrames = VideoProcessing.countFrames(in: AVAsset(url: self.video!))
        let poseCollection = PoseCollectionSerializable(poses: serializedPoses, setupFrame: self.setupFrame, backswingFrame: self.backswingFrame, impactFrame: self.impactFrame, totalFrames: totalFrames, leftArmAngleFrame: self.leftArmAngleFrame)
        
        let encoder = JSONEncoder()
        let poseJson = try! encoder.encode(poseCollection)
        
        // TEMPORARY ------------------------------------

        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last {
            let fileUrl = documentsDirectory.appendingPathComponent("swing.json")
            
            Swing.writePoseJsonToFile(fileUrl: fileUrl, json: poseJson)
        } else {
            print("Failed to load documents directory.")
        }

        // ------------------------------------------------
        
        request.httpBody = poseJson
        
        do {
            // Send request
            let (data, _) = try await URLSession.shared.data(for: request)
            let swingTipResults = try JSONDecoder().decode(SwingTipResults.self, from: data)
            
            let swingTempoMiniDesc = "More info"
            let swingTempoPassedDesc = "Good work, your swing's tempo is very smooth. Maintaining a smooth tempo in your swing is one of the most fundamental aspects to good ball-striking!"
            let swingTempoFailedDesc = "It looks like you're swinging a little quickly. If you get out-of-tempo, it can cause you to lose control of the club and produce inconsistencies in your ball contact. Try slowing your backswing down."
            
            // TEMPORARY CONTENT - SHOULD BE MOVED
            let leftArmAngleMiniDesc = "More info"
            let leftArmAnglePassedDesc = "Nice! You maintained a straight left arm in your backswing. This is important for making consistent ball contact."
            let leftArmAngleFailedDesc = "During your backswing your left arm was overly bent. Try and maintain a straight left arm to improve ball contact."
            
            let hipSwayMiniDesc = "More info"
            let hipSwayPassedDesc = "Good work. Your hips were very still during your swing. This is important for swing timing and consistent ball contact."
            let hipSwayFailedDesc = "You had too much movement in your hips during your backswing. Keep your hips still for much easier ball contact."
            
            let vertHeadMovementMiniDesc = "More info"
            let vertHeadMovementPassedDesc = "Well done. You didn't dip or raise your head during your swing. Ducking your head or standing up makes it very difficult to make clean contact."
            let vertHeadMovementFailedDesc = "Your head moved vertically too much during your swing. Keep a level head position to prevent topping or chunking the ball."
            
            let lateralHeadMovementMiniDesc = "More info"
            let lateralHeadMovementPassedDesc = "Nice! You had very little lateral head movement during your swing. This will help ensure you don't throw off your swing plane and mishit the ball."
            let lateralHeadMovementFailedDesc = "Your head moved laterally too much. Try and keep your head still to see major improvements in consistency."
            
            // Create swing tips w/ content
            var tips: [SwingTip] = []
            
            let tempoGood = swingTipResults.swingTempo >= 2.0
            tips.append(SwingTip(type: "Swing tempo", passed: tempoGood, miniDescription: swingTempoMiniDesc, passedDescription: swingTempoPassedDesc, failedDescription: swingTempoFailedDesc, help: ""))
            
            tips.append(SwingTip(type: "Left arm angle", passed: swingTipResults.leftArmAngle, miniDescription: leftArmAngleMiniDesc, passedDescription: leftArmAnglePassedDesc, failedDescription: leftArmAngleFailedDesc, help: ""))

            tips.append(SwingTip(type: "Hip sway", passed: swingTipResults.hipSway, miniDescription: hipSwayMiniDesc, passedDescription: hipSwayPassedDesc, failedDescription: hipSwayFailedDesc, help: ""))

            tips.append(SwingTip(type: "Vertical head movement", passed: swingTipResults.verticalHeadMovement, miniDescription: vertHeadMovementMiniDesc, passedDescription: vertHeadMovementPassedDesc, failedDescription: vertHeadMovementFailedDesc, help: ""))

            tips.append(SwingTip(type: "Lateral head movement", passed: swingTipResults.lateralHeadMovement, miniDescription: lateralHeadMovementMiniDesc, passedDescription: lateralHeadMovementPassedDesc, failedDescription: lateralHeadMovementFailedDesc, help: ""))
            
            return tips
        
        } catch {
            print("Error: \(error.localizedDescription)")
            return []
        }
    }

    
    func generateImages() {
        
        DispatchQueue.global().async {
            let setupImage = VideoProcessing.getFrameAsImage(frameNum: self.setupFrame, url: self.video!)
            let backswingImage = VideoProcessing.getFrameAsImage(frameNum: self.backswingFrame, url: self.video!)
            let impactImage = VideoProcessing.getFrameAsImage(frameNum: self.impactFrame, url: self.video!)
            
            while self.processing  {
                // Wait here until we have our posture info
                Thread.sleep(forTimeInterval: 0.1)
            }
            
            
            DispatchQueue.main.async {
                if self.landmarks[self.setupFrame] != nil {
                    let setupImageAnnotated = Swing.createAnnotatedUIImage(image: setupImage!, pose: self.landmarks[self.setupFrame]!)
                    let backswingImageAnnotated = Swing.createAnnotatedUIImage(image: backswingImage!, pose: self.landmarks[self.backswingFrame]!)
                    let impactImageAnnotated = Swing.createAnnotatedUIImage(image: impactImage!, pose: self.landmarks[self.impactFrame]!)
                    
                    self.setupImage = setupImageAnnotated.rotate(radians: .pi/2)
                    self.backswingImage = backswingImageAnnotated.rotate(radians: .pi/2)
                    self.impactImage = impactImageAnnotated.rotate(radians: .pi/2)
                } else {
                    print("ERROR: no human detected")
                    return
                }
                
            }
        }
    }
    
    /*
     Generates the pose landmarks for the swing instance
     */
    func generateLandmarks(usingFrames: [Int], increment: Int = 1) {
        self.processing = true      // used for activity indicator
        
        DispatchQueue.global().async {
            
            let asset = AVAsset(url: self.video!)
            let poses = VideoProcessing.extractFramesAndGeneratePoseData(from: asset, at: usingFrames, forSwing: self)
            let leftArmAngleFrame = self.detectFrameForArmAngle(poses: poses)
            self.leftArmAngleFrame = leftArmAngleFrame

                
            // Trigger UI updates on main thread
            DispatchQueue.main.async {
                self.landmarks = poses
                self.landmarksGenerated = true
                
                // Backend analysis begins
                self.analyzing = true
                // No longer processing posture
                self.processing = false
            }
        }
        
    }
    
    func detectFrameForArmAngle(poses: [Int: Pose]) -> Int {
        var minYDiff = Float.greatestFiniteMagnitude
        var minYDiffFrame = -1
        
        for (frame, pose) in poses {
            // Skip irrelevant frames
            if frame < self.setupFrame || frame > self.backswingFrame {
                continue
            }
            
            // find left hand & left shoulder
            var leftIndexLandmark: PoseLandmark?
            var leftShoulderLandmark: PoseLandmark?
            for landmark in pose.landmarks {
                if landmark.type == PoseLandmarkType.leftIndexFinger {
                    leftIndexLandmark = landmark
                }
                else if landmark.type == PoseLandmarkType.leftShoulder {
                    leftShoulderLandmark = landmark
                }
                if leftIndexLandmark != nil && leftShoulderLandmark != nil {
                    break
                }
            }
            
            if leftIndexLandmark == nil || leftShoulderLandmark == nil {
                continue
            }
            
            let diff = abs(Float(leftIndexLandmark!.position.y) - Float(leftShoulderLandmark!.position.y))
            if diff < minYDiff {
                minYDiff = diff
                minYDiffFrame = frame
                print("New min diff: \(diff) @ frame \(frame)")
            }
        }
        
        if minYDiffFrame == -1 {
            print("ERROR: couldn't detect left arm angle frame")
            return -1
        }
        
        print("--> Chosen frame: \(minYDiffFrame)")
        return minYDiffFrame
    }
    
    static func loadFromSavedAnalysis(savedAnalysis: SavedSwingAnalysis) -> Swing {
        // create swing object from analysis field
        // will be used by swing analyzer to pass swing object to analysis view
        
        let videoUrl = SavedSwingVideoManager.getSavedSwingVideoURL(videoName: savedAnalysis.videoName)
        
        let swing = Swing(url: videoUrl, id: savedAnalysis.id)

        swing.swingTips = savedAnalysis.swingTips
        swing.setupFrame = savedAnalysis.setupFrame
        swing.backswingFrame = savedAnalysis.backswingFrame
        swing.impactFrame = savedAnalysis.impactFrame
        swing.totalFrames = savedAnalysis.totalFrames
        swing.leftArmAngleFrame = savedAnalysis.leftArmAngleFrame
        
        swing.savedSetupPose = savedAnalysis.setupFramePose
        swing.savedBackswingPose = savedAnalysis.backswingFramePose
        swing.savedImpactPose = savedAnalysis.impactFramePose
        
        // load UIImages
        let setupImage = VideoProcessing.loadImage(imageName: savedAnalysis.setupImage)
        let backswingImage = VideoProcessing.loadImage(imageName: savedAnalysis.backswingImage)
        let impactImage = VideoProcessing.loadImage(imageName: savedAnalysis.impactImage)
        
        swing.setupImage = setupImage
        swing.backswingImage = backswingImage
        swing.impactImage = impactImage
        
        return swing
    }
    
    func regenerateImages() {
        
        DispatchQueue.global().async {
            let setupImage = VideoProcessing.getFrameAsImage(frameNum: self.setupFrame, url: self.video!)
            let backswingImage = VideoProcessing.getFrameAsImage(frameNum: self.backswingFrame, url: self.video!)
            let impactImage = VideoProcessing.getFrameAsImage(frameNum: self.impactFrame, url: self.video!)
            
            
            DispatchQueue.main.async {
                if self.landmarks[self.setupFrame] != nil {
                    let setupImageAnnotated = Swing.createAnnotatedUIImage(image: setupImage!, pose: self.landmarks[self.setupFrame]!)
                    let backswingImageAnnotated = Swing.createAnnotatedUIImage(image: backswingImage!, pose: self.landmarks[self.backswingFrame]!)
                    let impactImageAnnotated = Swing.createAnnotatedUIImage(image: impactImage!, pose: self.landmarks[self.impactFrame]!)
                    
                    self.setupImage = setupImageAnnotated.rotate(radians: .pi/2)
                    self.backswingImage = backswingImageAnnotated.rotate(radians: .pi/2)
                    self.impactImage = impactImageAnnotated.rotate(radians: .pi/2)
                    
                    self.regeneratingImages = false
                } else {
                    print("ERROR: no human detected")
                    return
                }
                
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
        let overlay = UIUtilities.createPoseOverlayView(forPose: pose, inViewWithBounds: imageView.bounds, lineWidth: 1.5, dotRadius: 4.0,
            positionTransformationClosure: { (position) -> CGPoint in
                return self.pointFrom(position).applying(transform)
            }
        )
        annotationOverlayView.addSubview(overlay)
        
        return self.createImageFromImageView(imageView: imageView, saveToPhotos: true)
        
    }
    
    private static func createImageFromImageView(imageView: UIImageView, saveToPhotos: Bool = false) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: imageView.bounds.size)
        let image = renderer.image { ctx in
            let res = imageView.drawHierarchy(in: imageView.bounds, afterScreenUpdates: true)
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
        }
            
        return imageView
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
