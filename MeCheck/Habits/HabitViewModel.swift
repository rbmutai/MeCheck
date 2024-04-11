//
//  HabitViewModel.swift
//  MeCheck
//
//  Created by Robert Mutai on 21/03/2024.
//

import Foundation

class HabitViewModel: ObservableObject {
    @Published var habits: [HabitItem] = []
    @Published var showSheet: Bool = false
    @Published var showAddSheet: Bool = false
    @Published var introMessage: String = String( localized: "It takes just 21 days to set a good habit or break a bad one. Click the plus button below to start")
    let persistence = PersistenceController.shared
   
    @Published var habitItem: HabitItem? = nil
    @Published var isEdit: Bool = false
    @Published var selectedPeriod: Frequency = .daily
    @Published var date = Date()
    init() {
        getHabits()
    }
    func getHabits() {
        habits = persistence.getHabits(date: date)
        isEdit = false
    }
    
    func stopHabit(id:Int) {
       persistence.stopHabit(id: id)
    }
    
    func trackHabit(habit: HabitItem) {
        persistence.trackHabit(id: habit.id, date: date)
    }
    
    func editHabit(item: HabitItem) {
        habitItem = item
        isEdit = true
        showAddSheet = true
    }
    
}
