//
//  HabitViewModel.swift
//  MeCheck
//
//  Created by Robert Mutai on 21/03/2024.
//

import Foundation

enum Frequency: String, CaseIterable, Decodable {
    case daily = "Daily"
    case weekly = "Weekly"
}

enum HabitColors: String, Decodable {
    case Purple = "Purple"
    case Blue = "Blue"
    case Brown = "Brown"
    case Green = "Green"
    case Maroon = "Maroon"
    case Pink = "Pink"
    case Yellow = "Yellow"
    case Peach = "Peach"
    case Red = "Red"
    case Orange = "Orange"
    case Sage = "Sage"
}

class HabitViewModel: ObservableObject {
    @Published var showSheet: Bool = false
    
    
}
