//
//  AppStore.swift
//  FallingWords2
//
//  Created by ashubin on 23.07.20.
//  Copyright © 2020 Alex Shubin. All rights reserved.
//

import Combine

class AppStore: ObservableObject {
    @Published var state: AppState

    init(state: AppState = AppState()) {
        self.state = state
    }

    func accept(_ event: AppEvent) {
        appReducer(state: &state, event: event)
    }
}
