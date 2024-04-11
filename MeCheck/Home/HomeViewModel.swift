//
//  HomeViewModel.swift
//  MeCheck
//
//  Created by Robert Mutai on 01/03/2024.
//

import Foundation
import Combine

enum Frequency: String, CaseIterable, Decodable {
    case daily = "Daily"
    case weekly = "Weekly"
    case monthly = "Monthly"
    case yearly = "Yearly"
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
    case LightGrey = "LightGrey"
    case ShadowBackground = "ShadowBackground"
    case Shadow = "Shadow"
}

class HomeViewModel: ObservableObject {
    
}
