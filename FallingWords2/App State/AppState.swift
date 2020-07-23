//
//  AppState.swift
//  FallingWords2
//
//  Created by ashubin on 22.07.20.
//  Copyright © 2020 Alex Shubin. All rights reserved.
//

enum AppEvent  {
    case answer(isCorrect: Bool)
}

struct AppState {
    var gameData = GameData.default
    var roundNumber = 0
    var gameResults = GameResults.empty
    var gameStarted = false

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
        } else {
            state.roundNumber += 1
        }
    }
}


