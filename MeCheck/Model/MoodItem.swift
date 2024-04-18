//
//  MoodItem.swift
//  MeCheck
//
//  Created by Robert Mutai on 12/03/2024.
//

import Foundation

struct MoodItem: Decodable, Identifiable, Hashable {
    var id: Int
    var morning: String
    var afternoon: String
    var evening: String
    var date: Date
}
