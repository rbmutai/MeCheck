//
//  HabitItem.swift
//  MeCheck
//
//  Created by Robert Mutai on 21/03/2024.
//

import Foundation

struct HabitItem: Decodable, Identifiable, Hashable {
    var id: Int
    var image: String
    var title: String
    var isQuit: Bool
    var backgroundColor: String
    var habitFrequency: Frequency
    var isChecked: Bool
    var trackCount: Int
    var trackDates: [Date] = []
    var completion: String = ""
    var streak: Int = 0
}
