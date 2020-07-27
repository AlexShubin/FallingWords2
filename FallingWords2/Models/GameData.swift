struct GameData: Equatable {
    let rounds: [RoundData]
}

struct RoundData: Equatable {
    let questionWord: String
    let answerWord: String
    let isTranslationCorrect: Bool
}

