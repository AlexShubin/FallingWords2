//
//  ScoreHistoryView.swift
//  FallingWords2
//
//  Created by ashubin on 23.07.20.
//  Copyright © 2020 Alex Shubin. All rights reserved.
//

import SwiftUI

struct ScoreHistoryView: View {
    @ObservedObject var store: Store<AppState,AppAction>

    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        return formatter
    }()

    var body: some View {
        NavigationView {
            List {
                ForEach(store.value.scoreHistory.activities) { activity in
                    VStack {
                        Text("Completed at: \(self.formatter.string(from: activity.timestamp))")
                            .foregroundColor(.blue)
                        Text("Correct answers: \(activity.results.rightAnswers)")

                        Text("Wrong answers: \(activity.results.wrongAnswers)")
                    }
                    .padding(4)
                }
                .onDelete { indexSet in
                    self.store.send(.removeActivities(indexSet: Set<Int>(indexSet)))
                }
            }
            .navigationBarTitle(Text("Score"))
        }
    }
}

struct ScoreHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        var state = AppState()
        state.scoreHistory.activities = [
            .init(timestamp: Date(),
                  results: .init(rightAnswers: 1, wrongAnswers: 1)),
            .init(timestamp: Date(timeIntervalSinceNow: 10),
            results: .init(rightAnswers: 5, wrongAnswers: 1)),
            .init(timestamp: Date(timeIntervalSinceNow: 20),
            results: .init(rightAnswers: 1, wrongAnswers: 5))
        ]
        return ScoreHistoryView(store: Store(initialValue: state, reducer: appReducer))
    }
}
