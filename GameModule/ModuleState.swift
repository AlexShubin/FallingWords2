import ComposableArchitecture
import Common
import ServiceKit

public enum ModuleAction: Equatable {
    case answer(isCorrect: Bool)
    case gameStarted
    case gameFinished
    case gameDataLoaded(GameData?)
    case reloadGameData
}

public enum GameDataState: Equatable {
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

public struct ModuleState: Equatable {
    public var gameData: GameDataState
    public var roundNumber: Int
    public var gameResults: GameResults
    public var gameStarted: Bool
    public var scoreHistory: ScoreHistory

    public init(
        gameData: GameDataState = .loading,
        roundNumber: Int = 0,
        gameResults: GameResults = .empty,
        gameStarted: Bool = false,
        scoreHistory: ScoreHistory = .empty
    ) {
        self.gameData = gameData
        self.roundNumber = roundNumber
        self.gameResults = gameResults
        self.gameStarted = gameStarted
        self.scoreHistory = scoreHistory
    }
}

public typealias ModuleEffect = Effect<ModuleAction, Never>
public typealias ModuleStore = Store<ModuleState, ModuleAction>

public let reducer = Reducer<ModuleState, ModuleAction, ModuleEnvironment> { state, action, environment in
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
                .init(id: environment.uuidProvider(),
                      timestamp: environment.dateProvider(),
                      results: state.gameResults),
                at: 0
            )
        } else {
            state.roundNumber += 1
        }
    case .gameStarted:
        state.gameData = .loading
        state.roundNumber = 0
        state.gameResults = .empty
        state.gameStarted = true
        return loadGameDataEffect(environment: environment)
    case .gameFinished:
        state.gameStarted = false
    case .gameDataLoaded(let data):
        state.gameData = data.map { .loaded($0) } ?? .failure
    case .reloadGameData:
        state.gameData = .loading
        return loadGameDataEffect(environment: environment)
    }
    return .none
}

private func loadGameDataEffect(environment: ModuleEnvironment) -> ModuleEffect {
    environment.gameDataProvider
        .provide(10)
        .map(ModuleAction.gameDataLoaded)
        .receive(on: environment.mainQueue)
        .eraseToEffect()
}
