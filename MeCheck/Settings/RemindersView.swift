//
//  RemindersView.swift
//  MeCheck
//
//  Created by Robert Mutai on 01/05/2024.
//

import SwiftUI

struct RemindersView: View {
    @ObservedObject var viewModel: RemindersViewModel
    var body: some View {
        ScrollView{
        VStack{
            VStack {
                ForEach(viewModel.reminders) { item in
                    HStack {
                        Image(systemName: "bell.fill")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundStyle(.secondary)
                            .padding()
                        Text(item.title)
                            .font(.IBMRegular(size: 15))
                        Text(viewModel.dateFormatter.string(from: item.time))
                            .font(.IBMRegular(size: 14))
                        
                        Spacer()
                        
                        Menu {
                            Button {
                                viewModel.editReminder(item: item)
                            } label: {
                                Label("Edit", systemImage: "square.and.pencil")
                            }
                            
                            Button(role: .destructive) {
                                viewModel.deleteReminder(id: item.id)
                                viewModel.getReminders()
                            } label: {
                                Label("Delete", systemImage: "trash.fill")
                            }
                            
                        } label: {
                            Image("more_vert", bundle: .none)
                                .font(.headline.weight(.bold))
                                .padding()
                                .foregroundStyle(.secondary)
                        }.tint(.darkGrey)
                        
                        
                    }
                    .modifier(CustomCard(cornerRadius:10))
                    .contextMenu {
                        
                        Button {
                            viewModel.editReminder(item: item)
                        } label: {
                            Label("Edit", systemImage: "square.and.pencil")
                        }
                        
                        Button(role: .destructive) {
                            viewModel.deleteReminder(id: item.id)
                            viewModel.getReminders()
                        } label: {
                            Label("Delete", systemImage: "trash.fill")
                        }
                        
                    }
                }
                
            }.padding()
            
            HStack {
                Image(systemName: "plus.circle.fill")
                Text("Add Reminder")
                    .font(.IBMSemiBold(size: 16))
            }
            .padding([.leading,.trailing], 30)
            .padding([.top,.bottom], 8)
            .background(.purple)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 15, height: 15)))
            .contentShape(Rectangle())
            .onTapGesture {
                viewModel.showSheet = true
            }
            
            Spacer()
        } .sheet(isPresented: $viewModel.showSheet, onDismiss: {
            viewModel.getReminders()
        }, content: {
            if viewModel.isEdit {
                AddReminderView(viewModel: AddReminderViewModel(reminder: viewModel.reminderItem), showSheet: $viewModel.showSheet)
            } else {
                AddReminderView(viewModel: AddReminderViewModel(), showSheet:  $viewModel.showSheet)
            }
            
        })
    }.navigationTitle("Reminders")
 }
}

#Preview {
    RemindersView(viewModel: RemindersViewModel())
}
