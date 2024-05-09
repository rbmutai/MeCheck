//
//  AppNavigation.swift
//  MeCheck
//
//  Created by Robert Mutai on 21/03/2024.
//

import Foundation
import SwiftUI

enum Route: Hashable {
    case home
    case intro
    case settings
    case subscriptions
    case reminders
}

class AppNavigation : ObservableObject {
    @Published var navigationPath: NavigationPath = NavigationPath()
   
    func navigate(route: Route)  {
        navigationPath.append(route)
    }
    
    //go back
    func pop()  {
        navigationPath.removeLast()
    }
    
    //signout
    func popToHome() {
        navigationPath.removeLast(navigationPath.count)
    }
}

