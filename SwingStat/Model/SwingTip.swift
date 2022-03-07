//
//  SwingTip.swift
//  SwingStat (iOS)
//
//  Created by Chris Sykes on 3/6/22.
//

import Foundation

struct SwingTip: Hashable, Codable {
    var type: String
    var passed: Bool
    var description: String
    var help: String
}
