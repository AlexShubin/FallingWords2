enum GameDataState: Equatable {
    case loading
    case loaded(GameData)
    case failure

    var data: GameData? {
        switch self {
        case .loaded(let data):
            return data
        default:
            return nil
        }
    }
}

struct GameData: Equatable {
    let rounds: [RoundData]
}

struct RoundData: Equatable {
    let questionWord: String
    let answerWord: String
    let isTranslationCorrect: Bool
}

