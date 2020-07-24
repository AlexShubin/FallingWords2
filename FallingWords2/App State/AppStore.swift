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
    private let reducer: (inout AppState, AppEvent) -> Void

    init(state: AppState, reducer: @escaping (inout AppState, AppEvent) -> Void) {
        self.state = state
        self.reducer = reducer
    }

    func accept(_ event: AppEvent) {
        reducer(&state, event)
    }
}
