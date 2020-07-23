//
//  TranslatedWord.swift
//  FallingWords2
//
//  Created by ashubin on 23.07.20.
//  Copyright © 2020 Alex Shubin. All rights reserved.
//

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
