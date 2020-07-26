import Foundation
import Combine

protocol RoundsDataProviderType {
    func roundsData(roundsCount: Int) -> AnyPublisher<[RoundData], Error>
}

struct RoundsDataProvider {
    private let translatedWordsLoader: TranslatedWordsLoaderType

    func roundsData(roundsCount: Int) -> AnyPublisher<[RoundData], Error> {
        translatedWordsLoader.translatedWords.map { allWords -> [RoundData] in
            let shuffledPrefix = allWords.shuffled().prefix(roundsCount)
            let half = roundsCount/2
            let halfOfRoundsCorrect = shuffledPrefix.prefix(half).map {
                return RoundData(questionWord: $0.eng,
                                 answerWord: $0.spa,
                                 isTranslationCorrect: true)
            }
            let halfOfRoundsCorrectOrNot: [RoundData] = shuffledPrefix.suffix(roundsCount-half).map {
                let allPossibleTranslations = Set(allWords.map { $0.spa })
                let answerWord = allPossibleTranslations.randomElement() ?? $0.spa
                return RoundData(questionWord: $0.eng,
                                 answerWord: answerWord,
                                 isTranslationCorrect: answerWord == $0.spa)
            }
            return (halfOfRoundsCorrect + halfOfRoundsCorrectOrNot).shuffled()
        }
        .eraseToAnyPublisher()
    }
}

protocol TranslatedWordsLoaderType {
    var translatedWords: AnyPublisher<[TranslatedWord], Error> { get }
} 

struct TranslatedWordsLoader: TranslatedWordsLoaderType {
    private let url = URL(string: "https://raw.githubusercontent.com/AlexShubin/FallingWords2/master/words.json")!

    private let urlSession = URLSession.shared

    private let decoder = JSONDecoder()

    var translatedWords: AnyPublisher<[TranslatedWord], Error> {
        urlSession.dataTaskPublisher(for: url)
            .map { data, _ in data }
            .decode(type: [TranslatedWord].self, decoder: decoder)
            .eraseToAnyPublisher()
    }
}
