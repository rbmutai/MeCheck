//
//  MoodChartItem.swift
//  MeCheck
//
//  Created by Robert Mutai on 13/03/2024.
//

import Foundation
struct MoodChartItem: Identifiable {
    var id = UUID()
    var timeOfDay: String
    var mood: String
}
