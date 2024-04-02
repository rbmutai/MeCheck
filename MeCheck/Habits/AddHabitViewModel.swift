//
//  AddHabitViewModel.swift
//  MeCheck
//
//  Created by Robert Mutai on 21/03/2024.
//

import Foundation

class AddHabitViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var icon: String = "🥁"
    @Published var backgoundColor: String = HabitColors.Purple.rawValue
    @Published var isQuit: Bool = false
    @Published var goal: String = "Daily"
    @Published var habitTheme: [HabitTheme] = [HabitTheme(id: 1, backgroundColor: HabitColors.Purple.rawValue), HabitTheme(id: 2, backgroundColor: HabitColors.Green.rawValue), HabitTheme(id: 3, backgroundColor: HabitColors.Sage.rawValue),HabitTheme(id: 4, backgroundColor: HabitColors.Brown.rawValue),HabitTheme(id: 5, backgroundColor: HabitColors.Yellow.rawValue), HabitTheme(id: 6, backgroundColor: HabitColors.Peach.rawValue),HabitTheme(id: 7, backgroundColor: HabitColors.Red.rawValue),HabitTheme(id: 8, backgroundColor: HabitColors.Pink.rawValue), HabitTheme(id: 9, backgroundColor: HabitColors.Orange.rawValue), HabitTheme(id: 10, backgroundColor: HabitColors.Blue.rawValue), HabitTheme(id: 11, backgroundColor: HabitColors.Maroon.rawValue)]

    @Published var selectedIndex: Int = 1
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    let persistence = PersistenceController.shared
    
    func updateTheme(selected: Int) {
        selectedIndex = selected
        backgoundColor = habitTheme[selected-1].backgroundColor
        
    }
    
    func saveHabit() {
        if name == "" {
            alertMessage = String( localized: "habit name?")
            showAlert = true
        } else {
            let habit = HabitItem(id: Int.random(in: 11..<1000000), image: icon, title: name, isQuit: isQuit, backgroundColor: backgoundColor, habitFrequency: goal == "Daily" ? .daily : .weekly, isChecked: false, trackCount: 0)
            persistence.saveHabit(habitItem: habit)
           
        }
        
    }
}
