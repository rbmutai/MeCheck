//
//  HabitStatsViewModel.swift
//  MeCheck
//
//  Created by Robert Mutai on 10/04/2024.
//

import Foundation

class HabitStatsViewModel: ObservableObject {
    @Published var numDays: CGFloat = 0
    @Published var selectedPeriod: Frequency
    @Published var date: Date
    let persistence = PersistenceController.shared
    init(selectedPeriod: Frequency, date: Date) {
        self.selectedPeriod = selectedPeriod
        self.date = date
        let range = Calendar.current.range(of: .day, in: .month, for: date)!
        numDays = CGFloat(range.count)
    }
    
    func getHabits() {
        
    }
}
