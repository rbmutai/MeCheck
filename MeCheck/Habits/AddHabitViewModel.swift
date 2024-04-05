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
    @Published var backgoundColor: String = HabitColors.Green.rawValue
    @Published var isQuit: Bool = false
    @Published var goal: String = "Daily"
    @Published var pageTitle: String = String(localized: "New Habit")
    @Published var addTitle: String = String(localized: "Create")
    @Published var habitTheme: [HabitTheme] = [HabitTheme(id: 1, backgroundColor: HabitColors.Green.rawValue), HabitTheme(id: 2, backgroundColor: HabitColors.Purple.rawValue), HabitTheme(id: 3, backgroundColor: HabitColors.Sage.rawValue),HabitTheme(id: 4, backgroundColor: HabitColors.Brown.rawValue),HabitTheme(id: 5, backgroundColor: HabitColors.Yellow.rawValue), HabitTheme(id: 6, backgroundColor: HabitColors.Peach.rawValue),HabitTheme(id: 7, backgroundColor: HabitColors.Red.rawValue),HabitTheme(id: 8, backgroundColor: HabitColors.Pink.rawValue), HabitTheme(id: 9, backgroundColor: HabitColors.Orange.rawValue), HabitTheme(id: 10, backgroundColor: HabitColors.Blue.rawValue), HabitTheme(id: 11, backgroundColor: HabitColors.Maroon.rawValue)]

    @Published var selectedIndex: Int = 1
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    let persistence = PersistenceController.shared
    var habitItem : HabitItem?
    
    init(habitItem: HabitItem? = nil) {
        self.habitItem = habitItem
        
        if let item = habitItem {
            backgoundColor = item.backgroundColor
            icon = item.image
            name = item.title
            isQuit = item.isQuit
            goal = item.habitFrequency.rawValue
            pageTitle = String(localized: "Edit Habit")
            addTitle = String(localized: "Save")
            selectedIndex = getSelectedIndex(backColor: item.backgroundColor)
        }
    }
    
    func getSelectedIndex(backColor: String)->Int {
        for i in 0..<habitTheme.count {
            if backColor == habitTheme[i].backgroundColor {
                return i+1
            }
        }
        return -1
    }
    
    func updateTheme(selected: Int) {
        selectedIndex = selected
        backgoundColor = habitTheme[selected-1].backgroundColor
    }
    
    func saveHabit() {
        if name == "" {
            alertMessage = String( localized: "habit name ?")
            showAlert = true
        } else {
            if habitItem == nil {
                let habit = HabitItem(id: Int.random(in: 11..<1000000), image: icon, title: name, isQuit: isQuit, backgroundColor: backgoundColor, habitFrequency: goal == "Daily" ? .daily : .weekly, isChecked: false, trackCount: 0)
                persistence.saveHabit(habitItem: habit)
            } else {
                
                habitItem?.backgroundColor = backgoundColor
                habitItem?.isQuit = isQuit
                habitItem?.image = icon
                habitItem?.title = name
                habitItem?.habitFrequency = goal == "Daily" ? .daily : .weekly
                
                if let item = habitItem {
                    persistence.updateHabit(habitItem: item)
                }
            }
           
        }
        
    }
}
