//
//  RemindersView.swift
//  MeCheck
//
//  Created by Robert Mutai on 01/05/2024.
//

import SwiftUI

struct RemindersView: View {
    @ObservedObject var viewModel: RemindersViewModel
    var body: some View {
        VStack{
            Text("Reminders!")
        }.navigationTitle("Reminders")
    }
}

#Preview {
    RemindersView(viewModel: RemindersViewModel())
}
