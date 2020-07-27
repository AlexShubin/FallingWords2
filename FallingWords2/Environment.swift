import Foundation

struct AppEnvironment {
    var gameDataProvider: GameDataProvider
    var dateProvider:  () -> Date

    static let live = AppEnvironment(
        gameDataProvider: .live(),
        dateProvider: Date.init
    )
}

#if DEBUG
extension AppEnvironment {
    static let mock = AppEnvironment(
        gameDataProvider: .mock,
        dateProvider: { Date(timeIntervalSince1970: 0) }
    )
}
#endif

