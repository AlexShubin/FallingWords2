import Foundation

public struct ModuleEnvironment {
    var gameDataProvider: GameDataProvider
    var dateProvider:  () -> Date

    public static let live = ModuleEnvironment(
        gameDataProvider: .live(),
        dateProvider: Date.init
    )
}

#if DEBUG
extension ModuleEnvironment {
    public static let mock = ModuleEnvironment(
        gameDataProvider: .mock,
        dateProvider: { Date(timeIntervalSince1970: 0) }
    )
}
#endif

