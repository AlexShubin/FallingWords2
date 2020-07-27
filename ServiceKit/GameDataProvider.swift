import Foundation
import Combine
import Common

public struct GameDataProvider {
    public let provide: (_ roundsCount: Int) -> AnyPublisher<GameData?, Never>

    static func make(
        translatedWordsLoader: TranslatedWordsLoader = .live,
        wordsShuffler: @escaping ([TranslatedWord]) -> [TranslatedWord] = { $0.shuffled() },
        roundsShuffler: @escaping ([RoundData]) -> [RoundData] = { $0.shuffled() }
    ) -> GameDataProvider {
        Self { roundsCount in
            return translatedWordsLoader.load()
                .map { allWords -> GameData? in
                    guard roundsCount <= allWords.count else { return nil }

                    let allWordsShuffled = wordsShuffler(allWords)
                    let shuffledPrefix = Array(allWordsShuffled.prefix(roundsCount))
                    let shuffledSuffix = Array(allWordsShuffled.suffix(roundsCount))

                    var result: [RoundData] = []

                    for i in (0..<roundsCount) {
                        if i < roundsCount/2 {
                            result.append(
                                .init(questionWord: shuffledPrefix[i].eng,
                                      answerWord: shuffledPrefix[i].spa,
                                      isTranslationCorrect: true)
                            )
                        } else {
                            result.append(
                                .init(questionWord: shuffledPrefix[i].eng,
                                      answerWord: shuffledSuffix[i].spa,
                                      isTranslationCorrect: shuffledSuffix[i].spa == shuffledPrefix[i].spa)
                            )
                        }
                    }

                    return GameData(rounds: roundsShuffler(result))
            }
            .replaceError(with: nil)
            .eraseToAnyPublisher()
        }
    }

    public static let live = GameDataProvider.make()

    #if DEBUG
    public static let mock = GameDataProvider { _ in
        Just(GameData(rounds: [
            .init(questionWord: "1", answerWord: "1t", isTranslationCorrect: true),
            .init(questionWord: "2", answerWord: "2t", isTranslationCorrect: true)
        ])).eraseToAnyPublisher()
    }
    #endif
}

struct TranslatedWordsLoader {
    let load: () -> AnyPublisher<[TranslatedWord], Error>

    private static let urlSession: URLSession  = {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil

        return URLSession(configuration: config)
    }()

    static let live = Self {
        let url = URL(string: "https://raw.githubusercontent.com/AlexShubin/FallingWords2/master/words.json")!
        
        return urlSession.dataTaskPublisher(for: url)
            .map { data, _ in data }
            .decode(type: [TranslatedWord].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}

struct TranslatedWord: Decodable, Equatable {
    let eng: String
    let spa: String

    // MARK: Decodable
    private enum CodingKeys: String, CodingKey {
        case eng = "text_eng"
        case spa = "text_spa"
    }
}
