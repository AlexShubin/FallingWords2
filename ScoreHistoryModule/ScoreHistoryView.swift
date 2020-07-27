import SwiftUI
import ComposableArchitecture

public struct ScoreHistoryView: View {
    let store: ModuleStore

    public init(store: ModuleStore) {
        self.store = store
    }

    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        return formatter
    }()

    public var body: some View {
        WithViewStore(self.store) { viewStore in
            NavigationView {
                List {
                    ForEach(viewStore.scoreHistory.activities) { activity in
                        VStack {
                            Text("Completed at: \(self.formatter.string(from: activity.timestamp))")
                                .foregroundColor(.blue)
                            Text("Correct answers: \(activity.results.rightAnswers)")

                            Text("Wrong answers: \(activity.results.wrongAnswers)")
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

struct ScoreHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        var state = ModuleState()
        state.scoreHistory.activities = [
            .init(timestamp: Date(),
                  results: .init(rightAnswers: 1, wrongAnswers: 1)),
            .init(timestamp: Date(timeIntervalSinceNow: 10),
            results: .init(rightAnswers: 5, wrongAnswers: 1)),
            .init(timestamp: Date(timeIntervalSinceNow: 20),
            results: .init(rightAnswers: 1, wrongAnswers: 5))
        ]
        return ScoreHistoryView(store: Store(initialState: state, reducer: reducer, environment: ()))
    }
}