import Foundation

public struct ScoreHistory: Equatable {
    public var activities: [Activity]

    public init(activities: [Activity]) {
        self.activities = activities
    }

    public struct Activity: Identifiable, Equatable {
        public let timestamp: Date
        public let results: GameResults

        public let id = UUID()

        public init (
            timestamp: Date,
            results: GameResults
        ) {
            self.timestamp = timestamp
            self.results = results
        }
    }

    public static let empty = ScoreHistory(activities: [])
}
