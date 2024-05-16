//
//  GratitudeViewModel.swift
//  MeCheck
//
//  Created by Robert Mutai on 04/04/2024.
//

import Foundation

class GratitudeViewModel: ObservableObject {
    @Published var introMessage: String = String( localized: "Keep a gratitude journal to record all the good things that happened during the day")
    @Published var todayMessage: String = String( localized: "Don't forget to add today's entry")
    @Published var gratitudes: [GratitudeItem] = []
    @Published var gratitudeDictionary: [Date: [GratitudeItem]] = [:]
    @Published var showSheet: Bool = false
    @Published var gratitudeItem: GratitudeItem? = nil
    @Published var isEdit: Bool = false
    @Published var selectedPeriod: Frequency = .monthly
    @Published var date = Date()
    let persistence = PersistenceController.shared
     var dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM dd"
        return formatter
    }()
    @Published var showAlert: Bool = false
    let alertMessage = String(localized: "Free MONTHLY limit of 15 reached, please upgrade to premium to add more")
    let alertTitle = String(localized: "Upgrade")
    var appNavigation: AppNavigation
    init(appNavigation: AppNavigation) {
        self.appNavigation = appNavigation
        getGratitude()
    }
    
    func getGratitude() {
        gratitudes = persistence.getGratitude(date: date)
        isEdit = false
        gratitudeDictionary = gratitudeByDay(gratitudes: gratitudes)
        
        if gratitudes.count == 1 {
            NotificationManager.setDefaultReminder()
        }
    }
    
    func deleteGratitude(id: Int) {
       persistence.deleteGratitude(id: id)
    }
    
    func editGratitude(item: GratitudeItem) {
        gratitudeItem = item
        isEdit = true
        showSheet = true
    }
    
    func gratitudeByDay(gratitudes: [GratitudeItem]) -> [Date:[GratitudeItem]] {
        guard !gratitudes.isEmpty else { return [:] }
        
//        let dictionaryByDay = Dictionary(grouping: gratitudes) { item -> Int in
//            let day = Calendar.current.dateComponents([.day], from: item.date).day!
//            return day
//        }
//        let range = Calendar.current.range(of: .day, in: .month, for: date)!
//        let numDays = range.count
//        let days = Array(1...numDays)
//        return days.compactMap({ dictionaryByDay[$0] })
        
        let dictionaryByDay = Dictionary(grouping: gratitudes) { item -> Date in
            let day = Calendar.current.dateComponents([.day,.month,.year], from: item.date)
            return Calendar.current.date(from: day)!
        }
       
        
        return dictionaryByDay
    }
    
}
