import Foundation
import GameModule

struct AppEnvironment {
    var gameModuleEnvironment: GameModule.ModuleEnvironment

    static let live = AppEnvironment(
        gameModuleEnvironment: .live
    )
}

#if DEBUG
extension AppEnvironment {
    static let mock = AppEnvironment(
        gameModuleEnvironment: .mock
    )
}
#endif

