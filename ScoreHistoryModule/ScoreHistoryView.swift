import SwiftUI
import ComposableArchitecture

public struct ScoreHistoryView: View {
    let store: ModuleStore
    let viewStateConverter = ScoreHistoryViewStateConverter.live

    public init(store: ModuleStore) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store.scope(state: viewStateConverter.convert)) { viewStore in
            NavigationView {
                List {
                    ForEach(viewStore.activities) { activity in
                        VStack {
                            Text("Completed at: \(activity.time))")
                                .foregroundColor(.blue)
                            Text("Correct answers: \(activity.rightAnswers)")

                            Text("Wrong answers: \(activity.wrongAnswers)")
                        }
                        .padding(4)
                    }
                    .onDelete { indexSet in
                        viewStore.send(.removeActivities(indexSet: Set<Int>(indexSet)))
                    }
                }
                .navigationBarTitle(Text("Score"))
            }
        }
    }
}

struct ScoreHistoryViewState: Equatable {
    let activities: [Activity]

    struct Activity: Identifiable, Equatable {
        let id: UUID
        let time: String
        let rightAnswers: Int
        let wrongAnswers: Int
    }
}

struct ScoreHistoryViewStateConverter {
    let convert: (ModuleState) -> ScoreHistoryViewState

    static func make(dateFormatter: ModuleDateFormatter) -> ScoreHistoryViewStateConverter {
        ScoreHistoryViewStateConverter {
            ScoreHistoryViewState(activities: $0.scoreHistory.activities.map {
                ScoreHistoryViewState.Activity(id: $0.id,
                                               time: dateFormatter.format($0.timestamp),
                                               rightAnswers: $0.results.rightAnswers,
                                               wrongAnswers: $0.results.wrongAnswers)
            })
        }
    }

    static let live = ScoreHistoryViewStateConverter.make(dateFormatter: ModuleDateFormatter.medium)
}

struct ScoreHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        var state = ModuleState()
        state.scoreHistory.activities = [
            .init(id: UUID(),
                  timestamp: Date(),
                  results: .init(rightAnswers: 1, wrongAnswers: 1)),
            .init(id: UUID(),
                  timestamp: Date(timeIntervalSinceNow: 10),
                  results: .init(rightAnswers: 5, wrongAnswers: 1)),
            .init(id: UUID(),
                  timestamp: Date(timeIntervalSinceNow: 20),
                  results: .init(rightAnswers: 1, wrongAnswers: 5))
        ]
        return ScoreHistoryView(store: Store(initialState: state, reducer: reducer, environment: ()))
    }
}
