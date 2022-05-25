//
//  SwingTipResult.swift
//  SwingStat (iOS)
//
//  Created by Connor Davis on 3/6/22.
//

import Foundation

struct SwingTipResults: Codable {
    var leftArmAngle: Bool
    var lateralHeadMovement: Bool
    var verticalHeadMovement: Bool
    var hipSway: Bool
    var swingTempo: Float
    var estimatedDistance: Float
}
