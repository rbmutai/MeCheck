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
    @AppStorage("darkModeOn") var darkModeOn: Bool = false
    var body: some Scene {
        WindowGroup {
            //ContentView()
              //  .environment(\.managedObjectContext, persistenceController.container.viewContext)
            NavigationStack(path: $appNavigation.navigationPath) {
                LandingView(appNavigation: appNavigation)
                    .preferredColorScheme(darkModeOn ? .dark : .light)
                    .navigationDestination(for: Route.self) { route in
                    switch route {
                        case .home:
                            HomeView(viewModel: HomeViewModel(appNavigation: appNavigation))
                        case .intro:
                            IntroView(viewModel: IntroViewModel(appNavigation: appNavigation))
                        case .settings:
                            SettingsView(viewModel: SettingsViewModel(appNavigation: appNavigation))
                        case .subscriptions:
                            SubscriptionsView(viewModel: SubscriptionsViewModel())
                        case .about:
                            AboutView(viewModel: AboutViewModel())
                        case .reminders:
                            RemindersView(viewModel: RemindersViewModel())
                        case .backup:
                            BackUpView(viewModel: BackUpViewModel())
                    }
                }
            }
            
        }
        //.environment(\.colorScheme, darkModeOn ? .dark : .light)
    }
}
