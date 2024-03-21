//
//  HabitView.swift
//  MeCheck
//
//  Created by Robert Mutai on 26/02/2024.
//

import SwiftUI

struct HabitView: View {
    @ObservedObject var viewModel: HabitViewModel
    @Binding var selectedTab: Int
    var body: some View {
        VStack {
        Spacer(minLength: 20)
        ScrollView {
            VStack{
                HStack {
                    Text("Add a habit to track")
                        .font(.IBMRegular(size: 16))
                    Image("add_circle", bundle: .none)
                }
                .padding(10)
                .opacity(0.7)
                .background(.quinary,in: RoundedRectangle(cornerRadius: 10.0, style: .circular))
                .sheet(isPresented: $viewModel.showSheet, onDismiss: {
                    selectedTab = 2
                }, content: {
                    HabitListView(viewModel: HabitListViewModel(), showsheet: $viewModel.showSheet)
                })
                .onTapGesture {
                    viewModel.showSheet = true
                }
                
                Spacer()
            }
        }
    }
    }
}


#Preview {
    HabitView(viewModel: HabitViewModel(), selectedTab: .constant(2))
}
