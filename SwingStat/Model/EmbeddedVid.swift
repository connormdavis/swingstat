//
//  EmbeddedVids.swift
//  SwingStat (iOS)
//
//  Created by Chris Sykes on 5/4/22.
//

import Foundation

struct EmbeddedVid: Codable, Hashable {
    // ID
    let uniqueID: Int
    
    // The type of swing tip
    let category: Int
    
    // The youtube URL
    let youTubeURL: String
}

extension EmbeddedVid: Identifiable {
    
    // The stable identity of the entity associated with this instance.
    var id: Int {
        self.uniqueID
    }
    
}

extension EmbeddedVid {
    static let all: [Self] = [
        .left_arm_angle_1,
        .left_arm_angle_2,
        .left_arm_angle_3,
        .lateral_head_movement_1,
        .lateral_head_movement_2,
        .lateral_head_movement_3,
        .vertical_head_movement_1,
        .vertical_head_movement_2,
        .vertical_head_movement_3,
        .hip_sway_1,
        .hip_sway_2,
        .hip_sway_3,
        .swing_tempo_1,
        .swing_tempo_2,
        .swing_tempo_3
    ]
}


extension EmbeddedVid {
    static let left_arm_angle_1: Self = .init(
        uniqueID: 1,
        category: 1,
        youTubeURL: "https://www.youtube.com/watch?v=_9LUqf2dOlc"
    )
    
    static let left_arm_angle_2: Self = .init(
        uniqueID: 2,
        category: 1,
        youTubeURL: "https://www.youtube.com/watch?v=V8nZeZ2xCtc"
    )
    
    static let left_arm_angle_3: Self = .init(
        uniqueID: 3,
        category: 1,
        youTubeURL: "https://www.youtube.com/watch?v=cjq9CSOkGVU"
    )
    
    static let lateral_head_movement_1: Self = .init(
        uniqueID: 4,
        category: 2,
        youTubeURL: "https://www.youtube.com/watch?v=t_OYJIiNcgs"
    )
    
    static let lateral_head_movement_2: Self = .init(
        uniqueID: 5,
        category: 2,
        youTubeURL: "https://www.youtube.com/watch?v=mksbOP0RSBw"
    )
    
    static let lateral_head_movement_3: Self = .init(
        uniqueID: 6,
        category: 2,
        youTubeURL: "https://www.youtube.com/watch?v=dOvl4m3zfzc"
    )
    
    static let vertical_head_movement_1: Self = .init(
        uniqueID: 7,
        category: 3,
        youTubeURL: "https://www.youtube.com/watch?v=dOvl4m3zfzc"
    )
    
    static let vertical_head_movement_2: Self = .init(
        uniqueID: 8,
        category: 3,
        youTubeURL: "https://www.youtube.com/watch?v=mksbOP0RSBw"
    )
    
    static let vertical_head_movement_3: Self = .init(
        uniqueID: 9,
        category: 3,
        youTubeURL: "https://www.youtube.com/watch?v=t_OYJIiNcgs"
    )
    
    static let hip_sway_1: Self = .init(
        uniqueID: 10,
        category: 4,
        youTubeURL: "https://www.youtube.com/watch?v=272bJ-bdU8E"
    )
    
    static let hip_sway_2: Self = .init(
        uniqueID: 11,
        category: 4,
        youTubeURL: "https://www.youtube.com/watch?v=bYQseMZmlas"
    )
    
    static let hip_sway_3: Self = .init(
        uniqueID: 12,
        category: 4,
        youTubeURL: "https://www.youtube.com/watch?v=99Hm22-188s"
    )
    static let swing_tempo_1: Self = .init(
        uniqueID: 13,
        category: 5,
        youTubeURL: "https://www.youtube.com/watch?v=DywlZqQzOMc"
    )
    
    static let swing_tempo_2: Self = .init(
        uniqueID: 14,
        category: 5,
        youTubeURL: "https://www.youtube.com/watch?v=t8npyrOQ9Os"
    )
    
    static let swing_tempo_3: Self = .init(
        uniqueID: 15,
        category: 5,
        youTubeURL: "https://www.youtube.com/watch?v=5HpuSI8MYlo"
    )
}
