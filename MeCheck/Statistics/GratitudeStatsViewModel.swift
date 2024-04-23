//
//  GratitudeStatsViewModel.swift
//  MeCheck
//
//  Created by Robert Mutai on 10/04/2024.
//

import Foundation

class GratitudeStatsViewModel: ObservableObject {
    @Published var selectedPeriod: Frequency
    @Published var date: Date
    @Published var gratitudeData: [GratitudeItem] = []
    @Published var responsibleData: [String: Int] = [:]
    @Published var feelingData: [String: Int] = [:]
    
    let emptyResponsibleData = [String(localized: "Family"): 3, String(localized: "Friend"): 3, String(localized: "Me"):10, String(localized: "School"): 8]
    let emptyFeelingData = ["😐":1, "🫠":3, "😁":6, "🤗":8, "🫢":10]
    let persistence = PersistenceController.shared
    init(selectedPeriod: Frequency, date: Date) {
        self.selectedPeriod = selectedPeriod
        self.date = date
        gratitudeData = persistence.getGratitude(date: date)
        responsibleData = gratitudeData.reduce(into: [:]) { $0[$1.responsible, default: 0] += 1 }
        feelingData = gratitudeData.reduce(into: [:]) { $0[$1.icon, default: 0] += 1 }
        
    }
    
    
}
