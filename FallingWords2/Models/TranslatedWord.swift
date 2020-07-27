import Foundation

struct TranslatedWord: Decodable, Equatable {
    let eng: String
    let spa: String

    // MARK: Decodable
    private enum CodingKeys: String, CodingKey {
        case eng = "text_eng"
        case spa = "text_spa"
    }
}
