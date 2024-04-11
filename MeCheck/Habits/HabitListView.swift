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
    @Binding  var showAddSheet: Bool
    @Binding  var date: Date
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
                Image(systemName: "plus.circle")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(.white)
                    .padding()
                    .background(.purple,in: RoundedRectangle(cornerRadius: 10.0, style: .circular))
                    
            }
            .modifier(CustomCard(cornerRadius:10))
            .frame(width: 320)
            .contentShape(Rectangle())
            .onTapGesture {
                showsheet = false
                showAddSheet = true
            }
            
            ScrollView {
                    VStack (alignment: .leading) {
                        Text("Good Habits to Set")
                            .font(.IBMRegular(size: 16))
                            .foregroundStyle(.secondary)
                            ForEach(viewModel.goodHabits) { item in
                                HabitRow(habitImage: item.image, habitLabel: item.title, habitBackround: item.backgroundColor) 
                                    .onTapGesture {
                                    viewModel.saveHabit(habit: item)
                                        date = Date()
                                    showsheet = false
                                    }.background(.shadowBackground)
                            }.shadow(color:.shadow ,radius: 10)
                    
                    }.padding()
                    
                    
                    
                VStack (alignment: .leading){
                        Text("Bad Habits to Break")
                        .font(.IBMRegular(size: 16))
                        .foregroundStyle(.secondary)
                            ForEach(viewModel.badHabits) { item in
                                HabitRow(habitImage: item.image, habitLabel: item.title, habitBackround: item.backgroundColor)
                                    .background(.shadowBackground)
                                    .onTapGesture {
                                    viewModel.saveHabit(habit: item)
                                        date = Date()
                                    showsheet = false
                                }.shadow(color:.shadow ,radius: 10)
                            }
                        
                    }.padding()
                    
            }
            
           
        }
        
    }
}

#Preview {
    HabitListView(viewModel: HabitListViewModel(), showsheet: .constant(true), showAddSheet: .constant(false), date: .constant(Date()))
}
