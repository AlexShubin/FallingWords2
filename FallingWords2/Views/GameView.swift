import SwiftUI

//struct GameViewState {
//    let questionWord: String
//    let answerWord: String
//    let rightAnswers: String
//    let wrongAnswers: String
//}

struct GameView: View {
    @ObservedObject var appState: AppState

    var body: some View {
        VStack(spacing: 20) {
            Text(appState.currentRound.questionWord)
            Text(appState.currentRound.answerWord)
            HStack(spacing: 20) {
                Button(action: { self.appState.accept(.answer(isCorrect: true)) },
                       label: { Text("YAY 🤗") })
                Button(action: { self.appState.accept(.answer(isCorrect: false)) },
                       label: { Text("NAY 😡") })
            }
            Text("Correct answer: \(appState.gameResults.rightAnswers)")
            Text("Wrong answers: \(appState.gameResults.wrongAnswers)")
        }
        .font(.title)
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(appState: AppState())
    }
}
