//
//  PoseLandmarkSerializable.swift
//  SwingStat (iOS)
//
//  Created by Connor Davis on 2/23/22.
//

import Foundation

struct PoseLandmarkSerializable: Codable {
    var inFrameLikelihood: Float
    var landmarkType: Int
    var position: Point3DSerializable
}
