//
//  GameResults.swift
//  FallingWords2
//
//  Created by ashubin on 22.07.20.
//  Copyright © 2020 Alex Shubin. All rights reserved.
//

struct GameResults: Equatable {
    var rightAnswers: Int
    var wrongAnswers: Int

    static let empty = GameResults(rightAnswers: 0, wrongAnswers: 0)
}
