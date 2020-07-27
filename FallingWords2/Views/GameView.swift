import SwiftUI
import ComposableArchitecture

struct GameView: View {
    let store: AppStore

    var body: some View {
        WithViewStore(store) { viewStore -> AnyView in
            switch viewStore.gameData {
            case .loading:
                return AnyView(Text("Loading...").font(.title))
            case .loaded(let gameData):
                return self.loadedBody(gameData: gameData)
            case .failure:
                return self.failedBody
            }
        }
    }

    private func loadedBody(gameData: GameData) -> AnyView {
        AnyView(
            WithViewStore(store) { viewStore in
                VStack(spacing: 20) {
                    Text(gameData.rounds[viewStore.state.roundNumber].questionWord)
                    Text(gameData.rounds[viewStore.state.roundNumber].answerWord)
                    HStack(spacing: 20) {
                        Button(action: { viewStore.send(.answer(isCorrect: true)) },
                               label: { Text("YAY 🤗") })
                        Button(action: { viewStore.send(.answer(isCorrect: false)) },
                               label: { Text("NAY 😡") })
                    }
                    Text("Correct answer: \(viewStore.state.gameResults.rightAnswers)")
                    Text("Wrong answers: \(viewStore.state.gameResults.wrongAnswers)")
                }
                .font(.title)
            }
        )
    }

    private var failedBody: AnyView {
        AnyView(
            WithViewStore(store) { viewStore in
                VStack(spacing: 20) {
                    Text("Oops! Something went wrong!")
                        .font(.subheadline)
                    Button(action: { viewStore.send(.reloadGameData) },
                           label: { Text("Try again") })
                        .font(.title)
                }
            }
        )
    }

}
