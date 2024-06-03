//
//  RemindersView.swift
//  MeCheck
//
//  Created by Robert Mutai on 01/05/2024.
//

import SwiftUI

struct RemindersView: View {
    @ObservedObject var viewModel: RemindersViewModel
    @Environment(\.scenePhase) var scenePhase
    @EnvironmentObject private var entitlementManager: EntitlementManager
    var body: some View {
        ScrollView {
            if viewModel.notificationsAllowed {
                RemindersViewSection
            } else {
                NoPermissionViewSection
            }
            
            if #available(iOS 17.0, *) {
                Spacer()
                    .onChange(of: scenePhase) { oldPhase, newPhase in
                        if newPhase == .active {
                            viewModel.checkReminderStatus()
                        }
                    }
            } else {
                // Fallback on earlier versions
                Spacer()
                    .onChange(of: scenePhase) { newPhase in
                        if newPhase == .active {
                            viewModel.checkReminderStatus()
                        }
                    }
            }
        }
        .navigationTitle("Reminders")
        
    }
}
private extension RemindersView {
    var RemindersViewSection: some View {
        VStack {
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
                Image(systemName: !entitlementManager.hasPro && viewModel.reminders.count > 0 ? "crown.fill" : "plus.circle.fill")
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
                if !entitlementManager.hasPro && viewModel.reminders.count > 0 {
                    //viewModel.showAlert = true
                    viewModel.goToPremium()
                } else{
                    viewModel.showSheet = true
                }
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
        .alert(viewModel.alertTitle, isPresented: $viewModel.showAlert) {
            NavigationLink(value: Route.subscriptions) {
                Button("View", action: {})
            }.buttonStyle(.plain)
            Button("Cancel", role: .cancel, action: {})
        } message: {
            Text(viewModel.alertMessage)
        }
    }
}
private extension RemindersView {
    var NoPermissionViewSection: some View {
        VStack {
            Spacer()
            Text("We don't have permission to send you notifications")
                .font(.IBMSemiBold(size: 18))
                .multilineTextAlignment(.center)
                .padding()
            
            Text("Please go to phone settings and enable notifications for \(Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? "MeCheck") make sure \"Allow Notifications\" is switched on")
                .font(.IBMRegular(size: 14))
                .multilineTextAlignment(.center)
                .padding()
           
            Button("Go to Settings") {
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }

                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    })
                }
            }
            .padding([.leading,.trailing], 20)
            .padding([.top,.bottom],8)
            .background(.purple)
            .clipShape(RoundedRectangle(cornerSize: CGSizeMake(15, 15)))
            .foregroundStyle(.white)
            .font(.IBMMedium(size: 16))
            Spacer()
        }
    }
}

#Preview {
    RemindersView(viewModel: RemindersViewModel(appNavigation: AppNavigation()))
        .environmentObject(EntitlementManager())
}
