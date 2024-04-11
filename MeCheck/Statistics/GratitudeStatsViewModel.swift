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
    init(selectedPeriod: Frequency, date: Date) {
        self.selectedPeriod = selectedPeriod
        self.date = date
    }
}
