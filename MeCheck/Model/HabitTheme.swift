//
//  HabitColor.swift
//  MeCheck
//
//  Created by Robert Mutai on 01/04/2024.
//

import Foundation

struct HabitTheme: Decodable, Identifiable, Hashable {
    var id: Int
    var backgroundColor: String
}
