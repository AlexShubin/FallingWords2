import SwiftUI
import ComposableArchitecture
import Common

struct GameView: View {
    let store: ModuleStore

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
                    Text(gameData.rounds[viewStore.roundNumber].questionWord)
                    Text(gameData.rounds[viewStore.roundNumber].answerWord)
                    HStack(spacing: 20) {
                        Button(action: { viewStore.send(.answer(isCorrect: true)) },
                               label: { Text("YAY 🤗") })
                        Button(action: { viewStore.send(.answer(isCorrect: false)) },
                               label: { Text("NAY 😡") })
                    }
                    Text("Correct answer: \(viewStore.gameResults.rightAnswers)")
                    Text("Wrong answers: \(viewStore.gameResults.wrongAnswers)")
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
                    Button(action: { viewStore.send(.gameStarted) },
                           label: { Text("Try again") })
                        .font(.title)
                }
            }
        )
    }

}
