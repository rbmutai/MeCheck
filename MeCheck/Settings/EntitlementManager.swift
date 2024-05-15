//
//  EntitlementManager.swift
//  MeCheck
//
//  Created by Robert Mutai on 11/05/2024.
//

import Foundation
import SwiftUI
class EntitlementManager: ObservableObject {
    static let userDefaults = UserDefaults.standard
    @AppStorage("hasPro", store: userDefaults)
    var hasPro: Bool = false
}
