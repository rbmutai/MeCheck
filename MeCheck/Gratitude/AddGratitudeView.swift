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
                    .overlay(content: { RoundedRectangle(cornerRadius: 12, style: .circular)
                        .strokeBorder(.lightGrey, lineWidth: 1)})
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
                    .padding(8)
                    .disableAutocorrection(true)
                    .border(.lightGrey)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                
                Text("How did it make you feel?")
                    .font(.IBMMedium(size: 15))
                    .padding([.top], 8)
                LazyVGrid(columns:
                            [GridItem(.adaptive(minimum: 40))], spacing: 10)  {
                    ForEach(0..<13 ) { i in
                        if i == viewModel.selectedIconIndex {
                            Text(viewModel.feel[i])
                                .font(.system(size: 30))
                                .padding(3)
                                .background(Color(HabitColors.LightGrey.rawValue, bundle: .main),in: RoundedRectangle(cornerRadius: 10.0, style: .circular))
                                .onTapGesture {
                                    viewModel.selectedIconIndex = i
                                }
                                
                            
                        } else {
                            Text(viewModel.feel[i])
                                .font(.system(size: 33))
                                .padding(3)
                                .onTapGesture {
                                    viewModel.selectedIconIndex = i
                                }
                        }
                    }
                }
                
                
                Text("Who was responsible for it?")
                    .font(.IBMMedium(size: 15))
                    .padding([.top,.bottom],8)
                
                LazyVGrid(columns: columns, alignment: .leading, spacing: 10)  {
                    ForEach(0..<9 ) { i in
                        
                        if i == viewModel.selectedResponsibleIndex {
                            Text(viewModel.responsible[i])
                                .font(.IBMRegular(size: 15))
                                .lineLimit(2)
                                .minimumScaleFactor(0.7)
                                .padding(10)
                                .background(Color(HabitColors.LightGrey.rawValue, bundle: .main),in: RoundedRectangle(cornerRadius: 12.0, style: .circular))
                                .onTapGesture {
                                    viewModel.selectedResponsibleIndex = i
                                }
                            
                        } else {
                            Text(viewModel.responsible[i])
                                .font(.IBMRegular(size: 15))
                                .lineLimit(2)
                                .minimumScaleFactor(0.7)
                                .padding(10)
                                .overlay(content: { RoundedRectangle(cornerRadius: 12, style: .circular)
                                    .strokeBorder(.lightGrey, lineWidth: 1)})
                                .onTapGesture {
                                    viewModel.selectedResponsibleIndex = i
                                }
                            
                        }
                        
                        
                    }
                    
                }
                
            }.padding([.leading,.trailing])
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
