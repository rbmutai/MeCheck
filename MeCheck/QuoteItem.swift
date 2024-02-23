//
//  QuoteItem.swift
//  MeCheck
//
//  Created by Robert Mutai on 01/03/2024.
//

import Foundation

struct QuoteItem: Decodable {
    let daily: DailyQuote
    let backgroundId: Int
    let date : Date
}
struct DailyQuote: Decodable {
    let id: Int
    let detail: String
    let author: String
}

