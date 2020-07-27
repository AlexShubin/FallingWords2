import SwiftUI

struct GameView: View {
    @ObservedObject var store: Store<AppState,AppAction>

    var body: some View {
        switch store.value.gameData {
        case .loading:
            return AnyView(Text("Loading...").font(.title))
        case .loaded(let gameData):
            return loadedBody(gameData: gameData)
        case .failure:
            return failedBody
        }
    }

    private func loadedBody(gameData: GameData) -> AnyView {
        AnyView(
            VStack(spacing: 20) {
                Text(gameData.rounds[store.value.roundNumber].questionWord)
                Text(gameData.rounds[store.value.roundNumber].answerWord)
                HStack(spacing: 20) {
                    Button(action: { self.store.send(.answer(isCorrect: true)) },
                           label: { Text("YAY 🤗") })
                    Button(action: { self.store.send(.answer(isCorrect: false)) },
                           label: { Text("NAY 😡") })
                }
                Text("Correct answer: \(store.value.gameResults.rightAnswers)")
                Text("Wrong answers: \(store.value.gameResults.wrongAnswers)")
            }
            .font(.title)
        )
    }

    private var failedBody: AnyView {
        AnyView(
            VStack(spacing: 20) {
                Text("Oops! Something went wrong!")
                    .font(.subheadline)
                Button(action: { self.store.send(.reloadGameData) },
                       label: { Text("Try again") })
                    .font(.title)
            }
        )
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(store: Store(initialValue: AppState(), reducer: appReducer))
    }
}
