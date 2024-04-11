//
//  GratitudeStatsView.swift
//  MeCheck
//
//  Created by Robert Mutai on 10/04/2024.
//

import SwiftUI

struct GratitudeStatsView: View {
    @ObservedObject var viewModel: GratitudeStatsViewModel
    var body: some View {
        ScrollView {
            VStack{
                Text("Gratitude Stats!")
            }
        }
    }
}

#Preview {
    GratitudeStatsView(viewModel: GratitudeStatsViewModel(selectedPeriod: .monthly, date: Date()))
}
