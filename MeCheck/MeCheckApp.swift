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

    var body: some Scene {
        WindowGroup {
            //ContentView()
              //  .environment(\.managedObjectContext, persistenceController.container.viewContext)
            HomeView(viewModel: HomeViewModel())
        }
    }
}
