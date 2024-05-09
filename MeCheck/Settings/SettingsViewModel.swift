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
    var shareInfo: String =  String(localized: "Hey, I use this great app called \(Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? "MeCheck"). It enables me to record my moods, set new habits and keep a gratitude journal. You can get it on the appstore at https://appstore.com/ ")
    init(appNavigation: AppNavigation) {
        self.appNavigation = appNavigation
    }
}
