//
//  PoseCollectionSerializable.swift
//  SwingStat (iOS)
//
//  Created by Connor Davis on 2/23/22.
//

import Foundation

struct PoseCollectionSerializable: Codable {
    var poses: [Int: PoseSerializable]
    var setupFrame: Int
    var backswingFrame: Int
    var impactFrame: Int
    var totalFrames: Int
    var leftArmAngleFrame: Int
}
