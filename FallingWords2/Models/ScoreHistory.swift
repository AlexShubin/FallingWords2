//
//  ScoreHistory.swift
//  FallingWords2
//
//  Created by ashubin on 23.07.20.
//  Copyright © 2020 Alex Shubin. All rights reserved.
//

import Foundation

struct ScoreHistory {
    var activities: [Activity]

    struct Activity: Identifiable {
        let timestamp: Date
        let results: GameResults

        let id = UUID()
    }

    static let empty = ScoreHistory(activities: [])
}
