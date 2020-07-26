import Foundation
import Combine

struct RoundsDataProvider {
    let provide: (_ roundsCount: Int) -> AnyPublisher<[RoundData], Error>

    static func `default`(
        translatedWordsLoader: TranslatedWordsLoader = .default,
        wordsShuffler: @escaping ([TranslatedWord]) -> [TranslatedWord] = { $0.shuffled() },
        roundsShuffler: @escaping ([RoundData]) -> [RoundData] = { $0.shuffled() }
    ) -> RoundsDataProvider {
        Self { roundsCount in
            translatedWordsLoader.load().tryMap { allWords -> [RoundData] in
                guard roundsCount <= allWords.count else { throw RoundsDataProviderError.notEnoughData }

                let allWordsShuffled = wordsShuffler(allWords)
                let shuffledPrefix = Array(allWordsShuffled.prefix(roundsCount))
                let shuffledSuffix = Array(allWordsShuffled.suffix(roundsCount))

                var result: [RoundData] = []

                for i in (0..<roundsCount) {
                    if i < roundsCount/2 {
                        result.append(.init(questionWord: shuffledPrefix[i].eng,
                                            answerWord: shuffledPrefix[i].spa,
                                            isTranslationCorrect: true))
                    } else {
                        result.append(.init(questionWord: shuffledPrefix[i].eng,
                                            answerWord: shuffledSuffix[i].spa,
                                            isTranslationCorrect: shuffledSuffix[i].spa == shuffledPrefix[i].spa))
                    }
                }

                return roundsShuffler(result)
            }
            .eraseToAnyPublisher()
        }
    }
}

enum RoundsDataProviderError: Error {
    case notEnoughData
}

struct TranslatedWordsLoader {
    let load: () -> AnyPublisher<[TranslatedWord], Error>

    static let `default` = Self {
        let url = URL(string: "https://raw.githubusercontent.com/AlexShubin/FallingWords2/master/words.json")!
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { data, _ in data }
            .decode(type: [TranslatedWord].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
