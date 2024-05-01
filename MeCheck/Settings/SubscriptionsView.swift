//
//  SubscriptionsView.swift
//  MeCheck
//
//  Created by Robert Mutai on 01/05/2024.
//

import SwiftUI

struct SubscriptionsView: View {
    @ObservedObject var viewModel: SubscriptionsViewModel
    var body: some View {
        VStack{
            Text("Subcriptions!")
        }.navigationTitle("Subcriptions")
       
    }
}

#Preview {
    SubscriptionsView(viewModel: SubscriptionsViewModel())
}
