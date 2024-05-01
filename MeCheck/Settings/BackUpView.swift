//
//  BackUpView.swift
//  MeCheck
//
//  Created by Robert Mutai on 01/05/2024.
//

import SwiftUI

struct BackUpView: View {
    @ObservedObject var viewModel: BackUpViewModel
    var body: some View {
        VStack{
            Text("Backup!")
        }.navigationTitle("Backup & Restore")
    }
}

#Preview {
    BackUpView(viewModel: BackUpViewModel())
}
