//
//  AppState.swift
//  FallingWords2
//
//  Created by ashubin on 22.07.20.
//  Copyright © 2020 Alex Shubin. All rights reserved.
//

import Combine

enum AppEvent  {
    case answer(isCorrect: Bool)
}

class AppState: ObservableObject {
    @Published var gameData = GameData.default
    @Published var roundNumber = 0
    @Published var gameResults = GameResults.empty
    @Published var gameStarted = false

    var currentRound: RoundData {
        gameData.rounds[min(roundNumber, gameData.rounds.count - 1)]
    }

    func accept(_ appEvent:  AppEvent) {
        switch appEvent {
        case .answer(let isCorrect):
            if isCorrect == currentRound.isTranslationCorrect {
                gameResults.rightAnswers += 1
            } else {
                gameResults.wrongAnswers += 1
            }
            roundNumber += 1
            if roundNumber >= gameData.rounds.count {
                gameStarted = false
            }
        }
    }
}


