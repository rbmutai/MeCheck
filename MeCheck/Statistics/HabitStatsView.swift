//
//  HabitStatsView.swift
//  MeCheck
//
//  Created by Robert Mutai on 10/04/2024.
//

import SwiftUI

struct HabitStatsView: View {
    @ObservedObject var viewModel: HabitStatsViewModel
    var body: some View {
        ScrollView {
            VStack{
                Text("Habit Stats!")
            }
        }
    }
}

#Preview {
    HabitStatsView(viewModel: HabitStatsViewModel(selectedPeriod: .monthly, date: Date()))
}
