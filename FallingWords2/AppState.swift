import Foundation
import ComposableArchitecture
import GameModule
import ScoreHistoryModule
import Common

enum AppAction: Equatable {
    case scoreHistoryModule(ScoreHistoryModule.ModuleAction)
    case gameModule(GameModule.ModuleAction)
}

struct AppState: Equatable {
    var gameData = GameDataState.loading
    var roundNumber = 0
    var gameResults = GameResults.empty
    var gameStarted = false
    var scoreHistory = ScoreHistory.empty

    var scoreHistoryModule: ScoreHistoryModule.ModuleState {
        get {
            .init(scoreHistory: scoreHistory)
        }
        set {
            scoreHistory = newValue.scoreHistory
        }
    }

    var gameModule: GameModule.ModuleState {
        get {
            .init(gameData: gameData,
                  roundNumber: roundNumber,
                  gameResults: gameResults,
                  gameStarted: gameStarted,
                  scoreHistory: scoreHistory)
        }
        set {
            gameData = newValue.gameData
            roundNumber = newValue.roundNumber
            gameResults = newValue.gameResults
            gameStarted = newValue.gameStarted
            scoreHistory = newValue.scoreHistory
        }
    }
}

typealias AppEffect = Effect<AppAction, Never>
typealias AppStore = Store<AppState, AppAction>

let appReducer = Reducer<AppState, AppAction, AppEnvironment>.combine([
    ScoreHistoryModule.reducer.pullback(
        state: \.scoreHistoryModule,
        action: /AppAction.scoreHistoryModule,
        environment: { _ in () }
    ),
    GameModule.reducer.pullback(
        state: \.gameModule,
        action: /AppAction.gameModule,
        environment: { $0.gameModuleEnvironment }
    ),
])


