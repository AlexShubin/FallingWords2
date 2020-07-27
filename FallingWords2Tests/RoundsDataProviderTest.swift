import XCTest
@testable import FallingWords2
import Combine

class RoundsDataProviderTests: XCTestCase {
    let sut = GameDataProvider.live(
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
    static let mock = Self {
        .just([.init(eng: "1", spa: "1t"),
               .init(eng: "2", spa: "2t"),
               .init(eng: "3", spa: "3t"),
               .init(eng: "4", spa: "4t")])
    }
}

private extension Publisher {
    static func just(_ output: Output) -> AnyPublisher<Output, Error> {
        return Just(output)
            .mapError(absurd)
            .eraseToAnyPublisher()
    }
}

private func absurd<A>(_ a: Never) -> A {}
