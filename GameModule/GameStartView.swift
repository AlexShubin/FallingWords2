import ComposableArchitecture
import SwiftUI

public struct GameStartView: View {
    let store: ModuleStore

    public init(store: ModuleStore) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store) { viewStore in
            VStack(spacing: 10) {
                Button(action: {
                    viewStore.send(.gameStarted)
                }, label: { Text("Start game") })
                    .font(.largeTitle)
                self.results
            }
            .sheet(isPresented: Binding.constant(viewStore.gameStarted),
                   onDismiss: { viewStore.send(.gameFinished) },
                   content: { GameView(store: self.store) })
        }
    }

    private var results: AnyView {
        AnyView(WithViewStore(store) { viewStore -> AnyView in
            if let gameResults = viewStore.scoreHistory.activities.first?.results {
                return AnyView(
                    VStack(spacing: 10) {
                        Text("Your latest result: ")
                            .font(.title)
                        Text("Correct answer: \(gameResults.rightAnswers)")
                        Text("Wrong answers: \(gameResults.wrongAnswers)")
                    }
                    .font(.headline)
                )
            }
            return AnyView(EmptyView())
        })
    }
}

struct GameStartView_Previews: PreviewProvider {
    static var previews: some View {
        var state = ModuleState()
        state.scoreHistory.activities = [
            .init(id: UUID(),
                  timestamp: Date(),
                  results: .init(rightAnswers: 1, wrongAnswers: 1))
        ]
        return GameStartView(store: Store(initialState: state, reducer: reducer, environment: .live))
    }
}
