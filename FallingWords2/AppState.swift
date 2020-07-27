import Foundation
import ComposableArchitecture

enum AppAction: Equatable {
    case answer(isCorrect: Bool)
    case removeActivities(indexSet: Set<Int>)
    case gameStarted(Bool)
    case gameDataLoaded(GameData?)
    case reloadGameData
}

struct AppState: Equatable {
    var gameData = GameDataState.loading
    var roundNumber = 0
    var gameResults = GameResults.empty
    var gameStarted = false

    var scoreHistory = ScoreHistory.empty
}

typealias AppEffect = Effect<AppAction, Never>

let appReducer = Reducer<AppState, AppAction, AppEnvironment> { state, action, environment in
    switch action {
    case .answer(let isCorrect):
        guard let gameData = state.gameData.data else {
            return .none
        }
        let currentRound = gameData.rounds[state.roundNumber]
        if isCorrect == currentRound.isTranslationCorrect {
            state.gameResults.rightAnswers += 1
        } else {
            state.gameResults.wrongAnswers += 1
        }
        if state.roundNumber == gameData.rounds.count - 1 {
            state.gameStarted = false
            state.scoreHistory.activities.insert(
                .init(timestamp: environment.dateProvider(), results: state.gameResults),
                at: 0
            )
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
        return loadGameDataEffect(dataProvider: environment.gameDataProvider)
    case .gameDataLoaded(let data):
        state.gameData = data.map { .loaded($0) } ?? .failure
    case .reloadGameData:
        state.gameData = .loading
        return loadGameDataEffect(dataProvider: environment.gameDataProvider)
    }
    return .none
}

private func loadGameDataEffect(dataProvider: GameDataProvider) -> AppEffect {
    dataProvider
        .provide(10)
        .map { AppAction.gameDataLoaded($0) }
        .receive(on: DispatchQueue.main)
        .eraseToEffect()
}


