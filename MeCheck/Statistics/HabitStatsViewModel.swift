//
//  HabitStatsViewModel.swift
//  MeCheck
//
//  Created by Robert Mutai on 10/04/2024.
//

import Foundation

class HabitStatsViewModel: ObservableObject {
    @Published var habitData: [HabitItem] = []
    @Published var numDays: CGFloat = 0
    @Published var selectedPeriod: Frequency
    @Published var date: Date
    let emptyData =  HabitItem(id: 1, image: "💦", title: String(localized: "Drink water"), isQuit: false, backgroundColor: HabitColors.Blue.rawValue, habitFrequency: .daily, isChecked: false, trackCount: 1,trackDates: [Calendar.current.date(byAdding: .day, value: 1, to: .now) ?? .now, Calendar.current.date(byAdding: .day, value: 2, to: .now) ?? .now, Calendar.current.date(byAdding: .day, value: 3, to: .now) ?? .now], completion: "40%", currentStreak: 5, longestStreak: 5 )
    let persistence = PersistenceController.shared
    init(selectedPeriod: Frequency = .monthly, date: Date) {
        self.selectedPeriod = selectedPeriod
        self.date = date
        let range = Calendar.current.range(of: .day, in: .month, for: date)!
        numDays = CGFloat(range.count)
        habitData = persistence.getHabitData(date: date, frequency: selectedPeriod)
    }
    

}
