//
//  UserData.swift
//  SwingStat (iOS)
//
//  Created by Connor Davis on 5/10/22.
//

import Foundation


struct UserData: Codable {
    var firstName: String
    var lastName: String
    var height: Float   // number of inches
    var swings: [SavedSwingAnalysis]
}
