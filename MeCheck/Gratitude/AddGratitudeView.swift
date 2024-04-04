//
//  AddGratitudeView.swift
//  MeCheck
//
//  Created by Robert Mutai on 04/04/2024.
//

import SwiftUI

struct AddGratitudeView: View {
    @ObservedObject var viewModel: AddGratitudeViewModel
    @Binding  var showSheet: Bool
    let columns = [
            GridItem(.adaptive(minimum: 80))
        ]
//    let columns = [
//            GridItem(.flexible()),
//            GridItem(.flexible()),
//            GridItem(.flexible()),
//            GridItem(.flexible())
//        ]
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
                    .overlay(RoundedRectangle(cornerRadius: 12, style: .circular)
                        .strokeBorder(.lightGrey, lineWidth: 1))
                    .padding()
                    .onTapGesture {
                        viewModel.saveGratitude()
                        if  !viewModel.showAlert {
                            showSheet = false
                        }
                    }
            }
            ScrollView {
            VStack(alignment: .leading) {
                Text("What good thing happened?")
                    .font(.IBMMedium(size: 15))
                
                TextEditor(text: $viewModel.detail)
                    .font(.IBMRegular(size: 14))
                    .frame(height: 80)
                    .lineSpacing(5)
                    .padding()
                    .disableAutocorrection(true)
                    .border(.lightGrey)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                
                Text("How did it make you feel?")
                    .font(.IBMMedium(size: 15))
                    .padding([.top])
                LazyVGrid(columns:
                            [GridItem(.adaptive(minimum: 45))], spacing: 15)  {
                    ForEach(0..<6 ) { i in
                        if i == viewModel.selectedIconIndex {
                            Text(viewModel.feel[i])
                                .font(.system(size: 39))
                                .padding(3)
                                .background(Color(HabitColors.LightGrey.rawValue, bundle: .main),in: RoundedRectangle(cornerRadius: 10.0, style: .circular))
                                .onTapGesture {
                                    viewModel.selectedIconIndex = i
                                }
                                
                            
                        } else {
                            Text(viewModel.feel[i])
                                .font(.system(size: 39))
                                .padding(3)
                                .onTapGesture {
                                    viewModel.selectedIconIndex = i
                                }
                        }
                    }
                }
                
                
                Text("Who was responsible for it?")
                    .font(.IBMMedium(size: 15))
                    .padding([.top])
                
                LazyVGrid(columns: columns, spacing: 15)  {
                    ForEach(0..<14 ) { i in
                        
                        if i == viewModel.selectedResponsibleIndex {
                            Text(viewModel.responsible[i])
                                .font(.IBMRegular(size: 15))
                                .lineLimit(1)
                                .fixedSize()
                                .padding(10)
                                .background(Color(HabitColors.LightGrey.rawValue, bundle: .main),in: RoundedRectangle(cornerRadius: 10.0, style: .circular))
                                .onTapGesture {
                                    viewModel.selectedResponsibleIndex = i
                                }
                            
                            
                        } else {
                            Text(viewModel.responsible[i])
                                .font(.IBMRegular(size: 15))
                                .lineLimit(1)
                                .fixedSize()
                                .padding(10)
                                .overlay(RoundedRectangle(cornerRadius: 12, style: .circular)
                                    .strokeBorder(.lightGrey, lineWidth: 1))
                                .onTapGesture {
                                    viewModel.selectedResponsibleIndex = i
                                }
                            
                            
                        }
                        
                        
                    }
                    
                }.padding()
                
               
                
                
            }.padding()
        }
            
            
            Spacer()
        }.alert(viewModel.alertMessage, isPresented: $viewModel.showAlert) {
            Button("Okay", role: .cancel, action: {})
        }
    }
}

#Preview {
    AddGratitudeView(viewModel: AddGratitudeViewModel(date: Date()), showSheet: .constant(true))
}
