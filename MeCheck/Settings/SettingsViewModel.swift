//
//  SettingsViewModel.swift
//  MeCheck
//
//  Created by Robert Mutai on 30/04/2024.
//

import Foundation
class SettingsViewModel: ObservableObject {
    
    private var appNavigation: AppNavigation
    @Published var subscription: SubscriptionPlan = .free
    @Published var darkModeOn: Bool = false
    init(appNavigation: AppNavigation) {
        self.appNavigation = appNavigation
    }
}
