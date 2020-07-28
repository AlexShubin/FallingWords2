import XCTest
@testable import ScoreHistoryModule
import Common
import ComposableArchitecture

class ScoreHistoryModuleTests: XCTestCase {
    func testRemoveActivities() {
        let testStore = TestStore(
            initialState: ModuleState(scoreHistory: .init(activities: [
                .init(timestamp: Date(timeIntervalSince1970: 0), results: GameResults.empty)
            ])),
            reducer: reducer,
            environment: ()
        )

        testStore.assert([
            .send(.removeActivities(indexSet: [0])) {
                $0.scoreHistory = .empty
            }
        ])
    }
}
