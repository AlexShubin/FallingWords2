//
//  AppState.swift
//  FallingWords2
//
//  Created by ashubin on 22.07.20.
//  Copyright © 2020 Alex Shubin. All rights reserved.
//

import Foundation

enum AppEvent  {
    case answer(isCorrect: Bool)
    case removeActivities(indexSet: Set<Int>)
}

struct AppState {
    var gameData = GameData.default
    var roundNumber = 0
    var gameResults = GameResults.empty
    var gameStarted = false

    var scoreHistory = ScoreHistory.empty

    var currentRound: RoundData {
        gameData.rounds[roundNumber]
    }
}

func appReducer(state: inout AppState, event: AppEvent) {
    switch event {
    case .answer(let isCorrect):
        if isCorrect == state.currentRound.isTranslationCorrect {
            state.gameResults.rightAnswers += 1
        } else {
            state.gameResults.wrongAnswers += 1
        }
        if state.roundNumber == state.gameData.rounds.count - 1 {
            state.gameStarted = false
            state.gameData = .default
            state.roundNumber = 0
            state.scoreHistory.activities.insert(.init(timestamp: Date(), results: state.gameResults), at: 0)
            state.gameResults = .empty
        } else {
            state.roundNumber += 1
        }
    case .removeActivities(let indexSet):
        indexSet.forEach {
            state.scoreHistory.activities.remove(at: $0)
        }
    }
}


