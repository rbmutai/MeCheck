//
//  HabitItem.swift
//  MeCheck
//
//  Created by Robert Mutai on 21/03/2024.
//

import Foundation

struct HabitItem: Decodable, Identifiable {
    var id: Int
    var image: String
    var title: String
    var detail: String
    var isQuit: Bool
    var backgroundColor: String
    var habitFrequency: Frequency
}
