//
//  StatsViewModel.swift
//  MeCheck
//
//  Created by Robert Mutai on 05/04/2024.
//

import Foundation

class StatsViewModel: ObservableObject {
    let segments: [MenuItem] = [MenuItem(id: 0, title: String(localized: "Mood"), icon: "mindfulness"), MenuItem(id: 1, title: String(localized: "Habits"), icon: "rule") , MenuItem(id: 2, title: String(localized: "Gratitude"), icon: "person_celebrate")]
    let period: [String] = [String(localized: "Monthly"), String(localized: "Yearly")]
    
    @Published var selectedSegment: String = ""
    @Published var selectedDataPeriod: String = ""
    var title: String {
        return selectedDataPeriod + " " + selectedSegment + " " + String(localized: "Statistics")
    }
    
    init() {
        selectedSegment = segments[0].title
        selectedDataPeriod = period[0]
    }
    
    func updateSelectedSegment(id:Int) {
        selectedSegment = segments[id].title
    }
    
    func updateSelectedPeriod(selected: String) {
        selectedDataPeriod = selected
    }
}
