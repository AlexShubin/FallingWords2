////
////  pr.swift
////  FallingWords2
////
////  Created by ashubin on 23.07.20.
////  Copyright © 2020 Alex Shubin. All rights reserved.
////
//
//import Foundation
//import Combine
//
//protocol RoundsDataProviderType {
//    func roundsData(roundsCount: Int) -> Future<[RoundData], Error>
//}
//
//struct RoundsDataProvider {
//
//    private let translatedWordsLoader: TranslatedWordsLoaderType
//
//    func roundsData(roundsCount: Int) -> Future<[RoundData], Error> {
//
//        Future {
//
//        }
//
////        let x = translatedWordsLoader.translatedWords.map { allWords -> [RoundData] in
////            let shuffledPrefix = allWords.shuffled().prefix(roundsCount)
////            let half = roundsCount/2
////            let halfOfRoundsCorrect = shuffledPrefix.prefix(half).map {
////                return RoundData(questionWord: $0.eng,
////                                 answerWord: $0.spa,
////                                 isTranslationCorrect: true)
////            }
////            let halfOfRoundsCorrectOrNot: [RoundData] = shuffledPrefix.suffix(roundsCount-half).map {
////                let allPossibleTranslations = Set(allWords.map { $0.spa })
////                let answerWord = allPossibleTranslations.randomElement() ?? $0.spa
////                return RoundData(questionWord: $0.eng,
////                                 answerWord: answerWord,
////                                 isTranslationCorrect: answerWord == $0.spa)
////            }
////            return (halfOfRoundsCorrect + halfOfRoundsCorrectOrNot).shuffled()
////        }
////        return x.eraseToAnyPublisher().
//    }
//}
//
//protocol TranslatedWordsLoaderType {
//    var translatedWords: Future<[TranslatedWord], TranslatedWordsLoaderError> { get }
//}
//
//enum TranslatedWordsLoaderError: Error {
//    case parsingError
//    case connectionError
//}
//
//struct TranslatedWordsLoader: TranslatedWordsLoaderType {
//    private let url = URL(string: "https://raw.githubusercontent.com/AlexShubin/FallingWords2/master/words.json")!
//
//    private let decoder = JSONDecoder()
//
//    var translatedWords: Future<[TranslatedWord], TranslatedWordsLoaderError> {
//        Future { promise in
//            guard let data = try? Data(contentsOf: self.url) else {
//                promise(.failure(TranslatedWordsLoaderError.connectionError))
//                return
//            }
//            guard let words = try? self.decoder.decode([TranslatedWord].self, from: data) else {
//                promise(.failure(TranslatedWordsLoaderError.parsingError))
//                return
//            }
//            promise(.success(words))
//        }
//    }
//}
