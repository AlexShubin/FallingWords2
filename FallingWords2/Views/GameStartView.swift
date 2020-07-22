//
//  GameStartView.swift
//  FallingWords2
//
//  Created by ashubin on 22.07.20.
//  Copyright © 2020 Alex Shubin. All rights reserved.
//

import SwiftUI

struct GameStartView: View {
    @ObservedObject var appState: AppState

    var body: some View {
        NavigationView {
            NavigationLink(
                destination: GameView(appState: appState),
                isActive: $appState.gameStarted,
                label: { Text("Start game") }
            )
        }
    }
}

struct GameStartView_Previews: PreviewProvider {
    static var previews: some View {
       GameStartView(appState: AppState())
    }
}
