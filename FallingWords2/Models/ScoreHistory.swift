import Foundation

struct ScoreHistory {
    var activities: [Activity]

    struct Activity: Identifiable {
        let timestamp: Date
        let results: GameResults

        let id = UUID()
    }

    static let empty = ScoreHistory(activities: [])
}
