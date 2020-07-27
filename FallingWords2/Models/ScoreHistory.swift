import Foundation

struct ScoreHistory: Equatable {
    var activities: [Activity]

    struct Activity: Identifiable, Equatable {
        let timestamp: Date
        let results: GameResults

        let id = UUID()
    }

    static let empty = ScoreHistory(activities: [])
}
