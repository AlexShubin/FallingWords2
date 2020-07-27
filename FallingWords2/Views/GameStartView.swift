//
//  GameStartView.swift
//  FallingWords2
//
//  Created by ashubin on 22.07.20.
//  Copyright © 2020 Alex Shubin. All rights reserved.
//

import SwiftUI

struct GameStartView: View {
    @ObservedObject var store: Store<AppState,AppAction>

    var body: some View {
        VStack(spacing: 10) {
            Button(action: {
                self.store.send(.gameStarted(true))
            }, label: { Text("Start game") })
                .font(.largeTitle)
            results
        }
        .sheet(isPresented: Binding.constant(store.value.gameStarted),
               onDismiss: { self.store.send(.gameStarted(false)) },
               content: { GameView(store: self.store) })
    }

    private var results: AnyView {
        if let gameResults = store.value.scoreHistory.activities.first?.results {
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
        return GameStartView(store: Store(initialValue: state, reducer: appReducer))
    }
}
