//
//  HabitListViewModel.swift
//  MeCheck
//
//  Created by Robert Mutai on 21/03/2024.
//

import Foundation

class HabitListViewModel: ObservableObject {
    @Published var goodHabits: [HabitItem] = [
        HabitItem(id: 1, image: "💦", title: String(localized: "Drink water"), isQuit: false, backgroundColor: HabitColors.Blue.rawValue, habitFrequency: .daily, isChecked: false),
        HabitItem(id: 2, image: "📚", title: String(localized: "Read a book"), isQuit: false, backgroundColor: HabitColors.Orange.rawValue, habitFrequency: .daily, isChecked: false),
        HabitItem(id: 3, image: "🚶", title: String(localized: "Go for a walk"), isQuit: false, backgroundColor: HabitColors.Green.rawValue, habitFrequency: .daily, isChecked: false),
        HabitItem(id: 4, image: "🤝", title: String(localized: "Appreciate someone"), isQuit: false, backgroundColor: HabitColors.Yellow.rawValue, habitFrequency: .daily, isChecked: false),
        HabitItem(id: 5, image: "🏃‍♀️", title: String(localized: "Exercise"), isQuit: false, backgroundColor: HabitColors.Brown.rawValue, habitFrequency: .daily, isChecked: false)]
    
    @Published var badHabits: [HabitItem] = [
        HabitItem(id: 6, image: "🚭", title: String(localized: "Quit smoking"), isQuit: true, backgroundColor: HabitColors.Brown.rawValue, habitFrequency: .daily, isChecked: false),
        HabitItem(id: 7, image: "😡", title: String(localized: "Don't lose your temper"), isQuit: true, backgroundColor: HabitColors.Red.rawValue, habitFrequency: .daily, isChecked: false),
        HabitItem(id: 8, image: "🍻", title: String(localized: "Quit alcohol"), isQuit: true, backgroundColor: HabitColors.Peach.rawValue, habitFrequency: .daily, isChecked: false),
        HabitItem(id: 9, image: "🤔", title: String(localized: "Stop overthinking"), isQuit: true, backgroundColor: HabitColors.Sage.rawValue, habitFrequency: .daily, isChecked: false),
        HabitItem(id: 10, image: "🛌", title: String(localized: "Stop procrastinating"), isQuit: true, backgroundColor: HabitColors.Purple.rawValue, habitFrequency: .daily, isChecked: false)]
    let persistence = PersistenceController.shared
    
    func saveHabit(habit: HabitItem) {
        persistence.saveHabit(habitItem: habit)
        
        
    }
    
}
