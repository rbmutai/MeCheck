//
//  AddReminderView.swift
//  MeCheck
//
//  Created by Robert Mutai on 06/05/2024.
//

import SwiftUI

struct AddReminderView: View {
    @ObservedObject var viewModel: AddReminderViewModel
    @Binding  var showSheet: Bool
    var body: some View {
        VStack{
            HStack {
                CloseImage()
                    .padding()
                    .onTapGesture {
                        showSheet = false
                    }
                Spacer()
                Text(viewModel.pageTitle)
                    .font(.IBMMedium(size: 16))
                Spacer()
                Text(viewModel.addTitle)
                    .font(.IBMRegular(size: 15))
                    .padding(10)
                    .modifier(CustomCard())
                    .padding()
                    .onTapGesture {
                        viewModel.saveReminder()
                        if  !viewModel.showAlert {
                            showSheet = false
                        }
                    }
            }
            ScrollView {
                VStack {
                    VStack(alignment: .leading) {
                        Text("Title")
                            .font(.IBMMedium(size: 15))
                        
                        TextField(
                            "",
                            text: $viewModel.title
                        )
                        .padding()
                        .frame(height: 40)
                        .disableAutocorrection(true)
                        .border(.lightGrey)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        
                        Text("Set Time")
                            .font(.IBMMedium(size: 15))
                            .padding([.top])
                        HStack {
                            Spacer()
                            DatePicker(
                                    "",
                                    selection: $viewModel.time,
                                    displayedComponents: [.hourAndMinute]
                            )
                            .datePickerStyle(.wheel)
                            .modifier(CustomCard())
                            .padding()
                            .frame(width: 300)
                            Spacer()
                        }
                        
                    }
                    
                }
                .padding()
                .alert(viewModel.alertMessage, isPresented: $viewModel.showAlert) {
                    Button("Okay", role: .cancel, action: {})
                }
                
            }
        }
    }
}

#Preview {
    AddReminderView(viewModel: AddReminderViewModel(), showSheet: .constant(true))
}
