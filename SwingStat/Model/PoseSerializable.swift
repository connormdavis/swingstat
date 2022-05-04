//
//  PoseSerializable.swift
//  SwingStat (iOS)
//
//  Created by Connor Davis on 2/23/22.
//

import Foundation
import MLKitPoseDetectionAccurate

struct PoseSerializable: Codable {
    
    var poseLandmarks: [Int: PoseLandmarkSerializable]
    
    static func convertTypeToInt(type: PoseLandmarkType) -> Int {
        switch type {
        case .nose:
            return 0
        case .leftEyeInner:
            return 1
        case .leftEye:
            return 2
        case .leftEyeOuter:
            return 3
        case .rightEyeInner:
            return 4
        case .rightEye:
            return 5
        case .rightEyeOuter:
            return 6
        case .leftEar:
            return 7
        case .rightEar:
            return 8
        case .mouthLeft:
            return 9
        case .mouthRight:
            return 10
        case .leftShoulder:
            return 11
        case .rightShoulder:
            return 12
        case .leftElbow:
            return 13
        case .rightElbow:
            return 14
        case .leftWrist:
            return 15
        case .rightWrist:
            return 16
        case .leftPinkyFinger:
            return 17
        case .rightPinkyFinger:
            return 18
        case .leftIndexFinger:
            return 19
        case .rightIndexFinger:
            return 20
        case .leftThumb:
            return 21
        case .rightThumb:
            return 22
        case .leftHip:
            return 23
        case .rightHip:
            return 24
        case .leftKnee:
            return 25
        case .rightKnee:
            return 26
        case .leftAnkle:
            return 27
        case .rightAnkle:
            return 28
        case .leftHeel:
            return 29
        case .rightHeel:
            return 30
        case .leftToe:
            return 31
        case .rightToe:
            return 32
        default:
            return -1
        }
    }
    
    static func loadFromPose(pose: Pose) -> PoseSerializable {
        var poseLandmarks: [Int: PoseLandmarkSerializable] = [:]
        for landmark in pose.landmarks {
            let inFrameLikelihood = landmark.inFrameLikelihood
            let landmarkType = PoseSerializable.convertTypeToInt(type: landmark.type)
            let position = landmark.position
            let x = Float(position.x)
            let y = Float(position.y)
            let z = Float(position.z)
            let landmarkSerializable = PoseLandmarkSerializable(inFrameLikelihood: inFrameLikelihood, landmarkType: landmarkType, position: Point3DSerializable(x: x, y: y, z: z))
            poseLandmarks[landmarkType] = landmarkSerializable
        }
        return PoseSerializable(poseLandmarks: poseLandmarks)
    }
    
}
