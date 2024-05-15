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
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var entitlementManager: EntitlementManager
    @StateObject private var subscriptionsManager: SubscriptionsViewModel
        
    init() {
        let entitlementManager = EntitlementManager()
        let subscriptionsManager = SubscriptionsViewModel(entitlementManager: entitlementManager)
        
        self._entitlementManager = StateObject(wrappedValue: entitlementManager)
        self._subscriptionsManager = StateObject(wrappedValue: subscriptionsManager)
    }
    
    var body: some Scene {
        WindowGroup {
            //ContentView()
              //  .environment(\.managedObjectContext, persistenceController.container.viewContext)
            NavigationStack(path: $appNavigation.navigationPath) {
                LandingView(appNavigation: appNavigation)
                    .environmentObject(entitlementManager)
                    .environmentObject(subscriptionsManager)
                    .task {
                        await subscriptionsManager.updatePurchasedProducts()
                    }
                    .preferredColorScheme(darkModeOn ? .dark : .light)
                    .navigationDestination(for: Route.self) { route in
                    switch route {
                        case .home:
                            HomeView(viewModel: HomeViewModel(appNavigation: appNavigation))
                            .environmentObject(entitlementManager)
                        case .intro:
                            IntroView(viewModel: IntroViewModel(appNavigation: appNavigation))
                        case .settings:
                            SettingsView(viewModel: SettingsViewModel(appNavigation: appNavigation))
                            .environmentObject(entitlementManager)
                        case .subscriptions:
                            SubscriptionsView()
                            .environmentObject(entitlementManager)
                            .environmentObject(subscriptionsManager)
                        case .reminders:
                            RemindersView(viewModel: RemindersViewModel())
                            .environmentObject(entitlementManager)
                    }
                }
            }
            
        }
        //.environment(\.colorScheme, darkModeOn ? .dark : .light)
    }
}
