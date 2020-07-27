import Foundation
import ComposableArchitecture
import Common

public enum ModuleAction: Equatable {
    case removeActivities(indexSet: Set<Int>)
}

public struct ModuleState: Equatable {
    public var scoreHistory: ScoreHistory

    public init(scoreHistory: ScoreHistory = .empty) {
        self.scoreHistory = scoreHistory
    }
}

public typealias ModuleEffect = Effect<ModuleAction, Never>
public typealias ModuleStore = Store<ModuleState, ModuleAction>

public let reducer = Reducer<ModuleState, ModuleAction, Void> { state, action, _ in
    switch action {
    case .removeActivities(let indexSet):
        indexSet.forEach {
            state.scoreHistory.activities.remove(at: $0)
        }
    }
    return .none
}


