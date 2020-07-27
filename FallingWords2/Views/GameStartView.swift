import ComposableArchitecture
import SwiftUI

struct GameStartView: View {
    let store: Store<AppState, AppAction>

    var body: some View {
        WithViewStore(store) { viewStore in
            VStack(spacing: 10) {
                Button(action: {
                    viewStore.send(.gameStarted(true))
                }, label: { Text("Start game") })
                    .font(.largeTitle)
                self.results(with: viewStore)
            }
            .sheet(isPresented: Binding.constant(viewStore.gameStarted),
                   onDismiss: { viewStore.send(.gameStarted(false)) },
                   content: { GameView(store: self.store) })
        }
    }

    private func results(with viewStore: ViewStore<AppState, AppAction>) -> AnyView {
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
    }
}

struct GameStartView_Previews: PreviewProvider {
    static var previews: some View {
        var state = AppState()
        state.scoreHistory.activities = [
            .init(timestamp: Date(),
                  results: .init(rightAnswers: 1, wrongAnswers: 1))
        ]
        return GameStartView(store: Store(initialState: state, reducer: appReducer, environment: .live))
    }
}
