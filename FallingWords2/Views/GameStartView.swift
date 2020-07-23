//
//  GameStartView.swift
//  FallingWords2
//
//  Created by ashubin on 22.07.20.
//  Copyright © 2020 Alex Shubin. All rights reserved.
//

import SwiftUI

struct GameStartView: View {
    @ObservedObject var appStore: AppStore

    var body: some View {
        NavigationView {
            VStack(spacing: 10) {
                NavigationLink(
                    destination: GameView(appStore: appStore),
                    isActive: $appStore.state.gameStarted,
                    label: { Text("Start game") }
                )
                    .font(.largeTitle)
                results
            }
        }
    }

    private var results: AnyView {
        if let gameResults = appStore.state.scoreHistory.activities.first?.results {
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
        return GameStartView(appStore: AppStore(state: state))
    }
}
