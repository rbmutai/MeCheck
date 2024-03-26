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
    case LightGrey = "LightGrey"
}

class HabitViewModel: ObservableObject {
    @Published var habits: [HabitItem] = []
    @Published var showSheet: Bool = false
    @Published var introMessage: String = String( localized: "It takes just 21 days to set a good habit or break a bad one. Click the plus button below to start")
    let persistence = PersistenceController.shared
    @Published var date: Date
    
    init(date: Date) {
        self.date = date
        getHabits()
    }
    func getHabits() {
        habits = persistence.getHabits(date: date)
    }
    
    func trackHabit(habit: HabitItem) {
        persistence.trackHabit(id: habit.id, title: habit.title, date: date)
    }
    
}
