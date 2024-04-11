//
//  MoodStatsView.swift
//  MeCheck
//
//  Created by Robert Mutai on 10/04/2024.
//

import SwiftUI

struct MoodStatsView: View {
    @ObservedObject var viewModel: MoodStatsViewModel
    var body: some View {
        ScrollView {
            VStack{
                Text("Mood Stats!")
            }
        }
    }
}

#Preview {
    MoodStatsView(viewModel: MoodStatsViewModel(selectedPeriod: .monthly, date: Date()))
}
