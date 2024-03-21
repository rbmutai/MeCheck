//
//  HabitListView.swift
//  MeCheck
//
//  Created by Robert Mutai on 21/03/2024.
//

import SwiftUI

struct HabitListView: View {
    @ObservedObject var viewModel: HabitListViewModel
    @Binding  var showsheet: Bool
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("Select a habit")
                    .font(.IBMMedium(size: 16))
                Spacer()
                CloseImage()
                    .padding()
                    .onTapGesture {
                        showsheet = false
                }
            }
            
            HStack {
               
                Text("Create your own custom habit")
                    .font(.IBMRegular(size: 15))
                    .padding([.leading],20)
                    
                Spacer()
                Image("add_circle", bundle: .none)
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundStyle(.secondary)
                    .padding()
                    .background(.quinary,in: RoundedRectangle(cornerRadius: 10.0, style: .circular))
                    .onTapGesture {
                        
                    }
            }
            .overlay(RoundedRectangle(cornerRadius: 10.0, style: .circular)
                .strokeBorder(.quaternary))
            .frame(width: 300)
            
            ScrollView {
                    List {
                        Section {
                            ForEach(viewModel.goodHabits) { item in
                                HabitRow(habitImage: item.image, habitLabel: item.title, habitBackround: item.backgroundColor)
                            }
                        } header: {
                            Text("Good Habits to Set")
                                
                        }
                    }
                    .frame(height: 445)
                    .scrollContentBackground(.hidden)
                    .scrollDisabled(true)
               
                    List {
                        Section {
                            ForEach(viewModel.badHabits) { item in
                                HabitRow(habitImage: item.image, habitLabel: item.title, habitBackround: item.backgroundColor)
                            }
                        } header: {
                            Text("Bad Habits to Break")
                        }
                        
                    }
                    .frame(height: 445)
                    .scrollContentBackground(.hidden)
                    .scrollDisabled(true)
                
                
            }
            
           
        }
        
    }
}

#Preview {
    HabitListView(viewModel: HabitListViewModel(), showsheet: .constant(true))
}
