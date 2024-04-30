//
//  StatsView.swift
//  MeCheck
//
//  Created by Robert Mutai on 26/02/2024.
//

import SwiftUI

struct StatsView: View {
    @ObservedObject var viewModel: StatsViewModel
    @State private var currentSegment = 1
    var body: some View {
        VStack {
            CustomHeader(selectedPeriod: $viewModel.selectedPeriod, date: $viewModel.date, appNavigation: viewModel.appNavigation)
            Spacer()
                .frame(height: 20)
            Picker("", selection: $currentSegment) {
                Text("Mood").tag(1)
                Text("Habits").tag(2)
                Text("Gratitude").tag(3)
            }
            .pickerStyle(.segmented)
            .padding(10)
            
            if currentSegment == 1 {
                MoodStatsView(viewModel: MoodStatsViewModel(selectedPeriod: viewModel.selectedPeriod, date: viewModel.date))
                
            } else if currentSegment == 2 {
                HabitStatsView(viewModel: HabitStatsViewModel(selectedPeriod: viewModel.selectedPeriod, date: viewModel.date))
                
            } else if currentSegment == 3 {
                GratitudeStatsView(viewModel: GratitudeStatsViewModel(selectedPeriod: viewModel.selectedPeriod, date: viewModel.date))
            }
            
        }
    }
}

#Preview {
    StatsView(viewModel: StatsViewModel(appNavigation: AppNavigation()))
}
