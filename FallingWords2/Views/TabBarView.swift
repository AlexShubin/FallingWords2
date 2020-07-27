import SwiftUI

struct TabBarView: View {
    let store: Store<AppState, AppAction>

    var body: some View {
        TabView{
            GameStartView(store: store).tabItem {
                    Image.game
                    Text("Game")
            }
            ScoreHistoryView(store: store).tabItem {
                    Image.list
                    Text("Score")
            }
        }
    }
}

private extension Image {
    static let game = Image(systemName: "gamecontroller.fill")
    static let list = Image(systemName: "list.dash")
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView(store: Store(initialValue: AppState(),
                                reducer: appReducer))
    }
}
