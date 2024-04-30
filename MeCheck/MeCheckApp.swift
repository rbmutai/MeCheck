//
//  MeCheckApp.swift
//  MeCheck
//
//  Created by Robert Mutai on 23/02/2024.
//

import SwiftUI

@main
struct MeCheckApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject private var appNavigation: AppNavigation = AppNavigation()
    var body: some Scene {
        WindowGroup {
            //ContentView()
              //  .environment(\.managedObjectContext, persistenceController.container.viewContext)
            NavigationStack(path: $appNavigation.navigationPath) {
                LandingView(appNavigation: appNavigation)
                    .navigationDestination(for: Route.self) { route in
                    switch route {
                        case .home:
                            HomeView(viewModel: HomeViewModel(appNavigation: appNavigation))
                        case .intro:
                            IntroView(viewModel: IntroViewModel(appNavigation: appNavigation))
                        case .settings:
                            SettingsView(viewModel: SettingsViewModel(appNavigation: appNavigation))
                    }
                }
            }
            
        }
    }
}
