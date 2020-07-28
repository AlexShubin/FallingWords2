import XCTest
@testable import ServiceKit
import Combine
import Common

class GameDataProviderTests: XCTestCase {
    let sut = GameDataProvider.make(
        translatedWordsLoader: .mock,
        wordsShuffler: { $0 },
        roundsShuffler: { $0 }
    )

    var cancellable: Cancellable?

    func testProviderHappyPath() {
        var result: GameData?
        cancellable = sut.provide(2)
            .sink(receiveCompletion: { _ in }) {
                result = $0
        }
        XCTAssertEqual(result, GameData(
            rounds: [
                .init(questionWord: "1", answerWord: "1t", isTranslationCorrect: true),
                .init(questionWord: "2", answerWord: "4t", isTranslationCorrect: false)
            ]
        ))
    }
}

private extension TranslatedWordsLoader {
    static let mock = TranslatedWordsLoader {
        Just([
            TranslatedWord(eng: "1", spa: "1t"),
            TranslatedWord(eng: "2", spa: "2t"),
            TranslatedWord(eng: "3", spa: "3t"),
            TranslatedWord(eng: "4", spa: "4t")
            ])
            .eraseToAnyPublisher()
    }
}
