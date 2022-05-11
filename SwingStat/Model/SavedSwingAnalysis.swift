//
//  SavedSwingAnalysis.swift
//  SwingStat (iOS)
//
//  Created by Connor Davis on 5/10/22.
//

import Foundation

struct SavedSwingAnalysis: Codable {
    var id: String
    var video: URL
    
    var swingTips: [SwingTip]
    var goodSwing: Bool
    
    var setupFrame: Int
    var setupFramePose: PoseSerializable
    
    var backswingFrame: Int
    var backswingFramePose: PoseSerializable
    
    var impactFrame: Int
    var impactFramePose: PoseSerializable
    
    var leftArmAngleFrame: Int
    var totalFrames: Int
    
    func getJson() -> Data {
        let encoder = JSONEncoder()
        let analysisJson = try! encoder.encode(self)
        return analysisJson
    }
}
