//
//  AboutView.swift
//  MeCheck
//
//  Created by Robert Mutai on 01/05/2024.
//

import SwiftUI

struct AboutView: View {
    @ObservedObject var viewModel: AboutViewModel
    var body: some View {
        VStack{
            Text("About!")
        }.navigationTitle("About")
       
    }
}

#Preview {
    AboutView(viewModel: AboutViewModel())
}
