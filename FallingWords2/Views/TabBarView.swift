//
//  TabBarView.swift
//  FallingWords2
//
//  Created by ashubin on 22.07.20.
//  Copyright © 2020 Alex Shubin. All rights reserved.
//

import SwiftUI

struct TabBarView: View {
    let appStore: AppStore

    var body: some View {
        TabView{
            GameStartView(appStore: appStore).tabItem {
                    Image.game
                    Text("Game")
            }
            Text("1").tabItem {
                    Image.list
                    Text("Score")
            }
            Text("1").tabItem {
                    Image.gear
                    Text("Settings")
            }
        }
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView(appStore: AppStore())
    }
}
