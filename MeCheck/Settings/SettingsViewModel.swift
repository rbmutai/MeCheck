//
//  SettingsViewModel.swift
//  MeCheck
//
//  Created by Robert Mutai on 30/04/2024.
//

import Foundation
class SettingsViewModel: ObservableObject {
    
    private var appNavigation: AppNavigation
    var shareInfo: String =  String(localized: "Hey, I use this great app called \(Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? "MeCheck"). It enables me to record my moods, set new habits and keep a gratitude journal. You can get it on the appstore at https://appstore.com/ ")
    let freeLabel = String(localized: "Free Version")
    let premiumLabel = String(localized: "Premium Version")
    init(appNavigation: AppNavigation) {
        self.appNavigation = appNavigation
        
    }
}
