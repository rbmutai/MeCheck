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
        ZStack(alignment: .bottomTrailing) {
        VStack {
            CustomHeader(selectedPeriod: $viewModel.selectedPeriod, date: $viewModel.date)
                VStack{
                    if viewModel.habits.isEmpty {
                        Text(viewModel.introMessage)
                            .multilineTextAlignment(.center)
                            .font(.IBMRegular(size: 16))
                            .padding()
                    } else {
                        List {
                            ForEach(viewModel.habits) { item in
                                HStack {
                                    Text(item.image)
                                        .font(.system(size: 39))
                                        .padding()
                                        .background(Color(item.backgroundColor, bundle: .main),in: RoundedRectangle(cornerRadius: 10.0, style: .circular))
                                    
                                    VStack {
                                        HStack {
                                            Text(item.title)
                                                .font(.IBMMedium(size: 15))
                                            Spacer()
                                        }
                                        
                                        HStack {
                                            Text(item.habitFrequency.rawValue).padding(8)
                                                .background(Color(item.backgroundColor, bundle: .main),in: Capsule())
                        
                                            if item.isQuit {
                                                Text("Quit")
                                                    .padding(8)
                                                    .background(Color(HabitColors.Red.rawValue, bundle: .main),in: Capsule())
                                            }
                                            
                                            Spacer()
                                            
                                        }
                                        .font(.IBMRegular(size: 13))
                                        
                                        
                                        
                                    }.padding([.bottom,.top],9)
                                    
                                    if item.trackCount > 0 {
                                        VStack {
                                            Text("\(item.trackCount)")
                                                .font(.IBMRegular(size: 13))
                                                .padding()
                                                .overlay(content: {
                                                    Circle()
                                                        .stroke(item.trackCount >= 21 ? Color.green : Color(HabitColors.Purple.rawValue, bundle: .main), lineWidth: 2)
                                                        .padding(6)
                                                })
                                        }
                                    }
                                    
                                    if item.isChecked {
                                        Image("task_alt")
                                            .font(.headline.weight(.semibold))
                                            .background(Color.green)
                                            .foregroundColor(.white)
                                            .clipShape(Circle())
                                            .padding()
                                    } else {
                                        Image("radio_button_unchecked", bundle: .none)
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                            .foregroundStyle(.secondary)
                                            .padding()
                                            .onTapGesture {
                                                viewModel.trackHabit(habit: item)
                                                viewModel.getHabits()
                                            }
                                    }
                                    
                                }.background(.shadowBackground)
                                .overlay(content: { RoundedRectangle(cornerRadius: 10.0, style: .circular).strokeBorder(item.isChecked ? Color.green : Color(HabitColors.LightGrey.rawValue, bundle: .main) , lineWidth: 1)})
                               
                                .swipeActions(allowsFullSwipe: false) {
                                        Button {
                                            viewModel.editHabit(item: item)
                                        } label: {
                                            Label("Edit", systemImage: "square.and.pencil")
                                        }
                                        .tint(.indigo)
                                        
                                        Button(role: .destructive) {
                                            viewModel.stopHabit(id: item.id)
                                        } label: {
                                            Label("Delete", systemImage: "trash.fill")
                                        }
                                    }
                                .contextMenu {
                                    
                                    Button {
                                        viewModel.editHabit(item: item)
                                    } label: {
                                        Label("Edit", systemImage: "square.and.pencil")
                                    }
                                   
                                    Button(role: .destructive) {
                                        viewModel.stopHabit(id: item.id)
                                        viewModel.getHabits()
                                    } label: {
                                        Label("Delete", systemImage: "trash.fill")
                                    }
                                    
                                }
                                        
                            }
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                            .listRowInsets(.init(top: 7, leading: 0, bottom: 7, trailing: 0))
                            .shadow(color:.shadow ,radius: 10)
                            
                        }
                        .scrollContentBackground(.hidden)
                        .background(.clear)
                        
                        
                    }
                    
                    if #available(iOS 17.0, *) {
                        Spacer().onChange(of: viewModel.date) { oldValue, newValue in
                            viewModel.getHabits()
                        }
                    } else {
                        // Fallback on earlier versions
                        Spacer().onChange(of: viewModel.date) { _ in
                            viewModel.getHabits()
                            
                            }
                    }
                }
        
        }.onAppear(perform: {
            viewModel.getHabits()
        })
            //button
        Button {
            viewModel.showSheet = true
        } label: {
            Image(systemName: "plus")
                .font(.headline.weight(.semibold))
                .padding()
                .background(Color.purple)
                .foregroundColor(.white)
                .clipShape(Circle())
        }
            .padding()
            .sheet(isPresented: $viewModel.showSheet, onDismiss: {
                selectedTab = 2
                viewModel.getHabits()
            }, content: {
                HabitListView(viewModel: HabitListViewModel(), showsheet: $viewModel.showSheet,showAddSheet: $viewModel.showAddSheet, date: $viewModel.date)
            })
                    
      }.sheet(isPresented: $viewModel.showAddSheet, onDismiss: {
          selectedTab = 2
          viewModel.getHabits()
      }, content: {
          if viewModel.isEdit {
              AddHabitView(viewModel: AddHabitViewModel(habitItem: viewModel.habitItem), showAddSheet: $viewModel.showAddSheet)
          } else {
              AddHabitView(viewModel: AddHabitViewModel(), showAddSheet: $viewModel.showAddSheet)
          }
          
      })
        
        
    }
}


#Preview {
    HabitView(viewModel: HabitViewModel(), selectedTab: .constant(2))
}
