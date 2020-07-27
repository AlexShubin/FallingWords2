import Foundation

enum AppAction  {
    case answer(isCorrect: Bool)
    case removeActivities(indexSet: Set<Int>)
    case gameStarted(Bool)
    case gameDataLoaded(GameData?)
    case reloadGameData
}

struct AppState {
    var gameData = GameDataState.loading
    var roundNumber = 0
    var gameResults = GameResults.empty
    var gameStarted = false

    var scoreHistory = ScoreHistory.empty
}

func appReducer(state: inout AppState, action: AppAction) -> [Effect<AppAction>] {
    switch action {
    case .answer(let isCorrect):
        guard let gameData = state.gameData.data else {
            return []
        }
        let currentRound = gameData.rounds[state.roundNumber]
        if isCorrect == currentRound.isTranslationCorrect {
            state.gameResults.rightAnswers += 1
        } else {
            state.gameResults.wrongAnswers += 1
        }
        if state.roundNumber == gameData.rounds.count - 1 {
            state.gameStarted = false
            state.scoreHistory.activities.insert(.init(timestamp: Date(), results: state.gameResults), at: 0)
        } else {
            state.roundNumber += 1
        }
    case .removeActivities(let indexSet):
        indexSet.forEach {
            state.scoreHistory.activities.remove(at: $0)
        }
    case .gameStarted(let started):
        if started {
            state.gameData = .loading
            state.roundNumber = 0
            state.gameResults = .empty
            state.gameData = .loading
        }
        state.gameStarted = started
        return [loadGameDataEffect]
    case .gameDataLoaded(let data):
        state.gameData = data.map { .loaded($0) } ?? .failure
    case .reloadGameData:
        state.gameData = .loading
        return [loadGameDataEffect]
    }
    return []
}

private var loadGameDataEffect: Effect<AppAction> {
    GameDataProvider.default()
        .provide(10)
        .map { AppAction.gameDataLoaded($0) }
        .receive(on: DispatchQueue.main)
        .eraseToEffect()
}


