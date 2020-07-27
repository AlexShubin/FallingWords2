import SwiftUI

struct GameView: View {
    @ObservedObject var store: Store<AppState,AppAction>

    var body: some View {
        VStack(spacing: 20) {
            Text(store.value.currentRound.questionWord)
            Text(store.value.currentRound.answerWord)
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
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(store: Store(initialValue: AppState(), reducer: appReducer))
    }
}
