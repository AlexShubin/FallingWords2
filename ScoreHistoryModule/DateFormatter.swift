import Foundation

struct ModuleDateFormatter {
    var format: (Date) -> String

    private static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        return formatter
    }()

    static let medium = ModuleDateFormatter(
        format: { formatter.string(from: $0) }
    )
}

#if DEBUG
extension ModuleDateFormatter {
    public static let mock = ModuleDateFormatter(
        format: { _ in "" }
    )
}
#endif

