//
//  MoreView.swift
//  MeCheck
//
//  Created by Robert Mutai on 26/02/2024.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: SettingsViewModel
    var body: some View {
        VStack{
            Text("Settings")
        }.navigationTitle("Settings")
        
    }
}

#Preview {
    SettingsView(viewModel: SettingsViewModel(appNavigation: AppNavigation()))
}
