import SwiftUI

struct GameView: View {
    @ObservedObject var appStore: AppStore

    var body: some View {
        VStack(spacing: 20) {
            Text(appStore.state.currentRound.questionWord)
            Text(appStore.state.currentRound.answerWord)
            HStack(spacing: 20) {
                Button(action: { self.appStore.accept(.answer(isCorrect: true)) },
                       label: { Text("YAY 🤗") })
                Button(action: { self.appStore.accept(.answer(isCorrect: false)) },
                       label: { Text("NAY 😡") })
            }
            Text("Correct answer: \(appStore.state.gameResults.rightAnswers)")
            Text("Wrong answers: \(appStore.state.gameResults.wrongAnswers)")
        }
        .font(.title)
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(appStore: AppStore(state: AppState(), reducer: appReducer))
    }
}
