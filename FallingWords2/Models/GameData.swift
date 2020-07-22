//
//  RoundData.swift
//  FallingWords2
//
//  Created by ashubin on 22.07.20.
//  Copyright © 2020 Alex Shubin. All rights reserved.
//

struct GameData: Equatable {
    let rounds: [RoundData]
}

struct RoundData: Equatable {
    let questionWord: String
    let answerWord: String
    let isTranslationCorrect: Bool
}

extension GameData {
    static let `default` = GameData(rounds: [
        .init(questionWord: "Yes", answerWord: "Нет", isTranslationCorrect: false),
        .init(questionWord: "Cat", answerWord: "Кошка", isTranslationCorrect: true),
        .init(questionWord: "Good", answerWord: "Хорошо", isTranslationCorrect: true),
        .init(questionWord: "Bad", answerWord: "Плохо", isTranslationCorrect: true),
        .init(questionWord: "No", answerWord: "Да", isTranslationCorrect: false),
        .init(questionWord: "Dog", answerWord: "Собака", isTranslationCorrect: true),
        .init(questionWord: "Hi", answerWord: "Привет", isTranslationCorrect: true)
    ])
}

