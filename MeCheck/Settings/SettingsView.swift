//
//  MoreView.swift
//  MeCheck
//
//  Created by Robert Mutai on 26/02/2024.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: SettingsViewModel
    var body: some View {
        VStack {
            NavigationLink(value: Route.subscriptions) {
                HStack {
                    Text("\(viewModel.subscription.rawValue) Version")
                        .font(.IBMMedium(size: 16))
                        .foregroundStyle(.darkGrey)
                        
                    Spacer()
                    
                    if viewModel.subscription == .free {
                        Text("UPGRADE")
                            .font(.IBMMedium(size: 13))
                            .padding([.leading,.trailing])
                            .padding([.top,.bottom], 5)
                            .background(.purple)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 15, height: 15)))
                        Spacer()
                    }
                   
                    Image(systemName: "chevron.right")
                        .foregroundStyle(.darkGrey)
                }
                .padding()
                .modifier(CustomCard())
                .padding()
                
            }
            
            HStack {
                VStack (alignment:.leading){
                    Text("Dark Mode")
                        .font(.IBMMedium(size: 16))
                        .foregroundStyle(.darkGrey)
                    Text(viewModel.darkModeOn ? "Enabled": "Disabled")
                        .font(.IBMRegular(size: 13))
                        .foregroundStyle(.darkGrey)
                }
                Toggle("", isOn: $viewModel.darkModeOn)
                Spacer()
            }
            .padding()
            .modifier(CustomCard())
            .padding()
            
            VStack {
                NavigationLink(value: Route.backup) {
                    VStack {
                        HStack {
                            Text("Backup & Restore")
                                .font(.IBMMedium(size: 16))
                                .foregroundStyle(.darkGrey)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundStyle(.darkGrey)
                        }
                        Divider().padding([.bottom],5)
                    }
                    
                }
                
                NavigationLink(value: Route.reminders) {
                    VStack {
                        HStack {
                            Text("Reminders")
                                .font(.IBMMedium(size: 16))
                                .foregroundStyle(.darkGrey)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundStyle(.darkGrey)
                        }
                        Divider().padding([.bottom],5)
                    }
                    
                }
                NavigationLink(value: Route.subscriptions) {
                    VStack {
                        HStack {
                            Text("Subscriptions")
                                .font(.IBMMedium(size: 16))
                                .foregroundStyle(.darkGrey)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundStyle(.darkGrey)
                        }
                        
                    }
                    
                }
                
            }
            .padding()
            .modifier(CustomCard())
            .padding()
            
            VStack {
                    VStack {
                        HStack {
                            Text("Rate 5 Stars")
                                .font(.IBMMedium(size: 16))
                                .foregroundStyle(.darkGrey)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundStyle(.darkGrey)
                        }
                        Divider().padding([.bottom],5)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                       
                    }
                
                    VStack {
                        HStack {
                            Text("Tell your Friends")
                                .font(.IBMMedium(size: 16))
                                .foregroundStyle(.darkGrey)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundStyle(.darkGrey)
                        }
                        Divider().padding([.bottom],5)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
        
                    }
                    
               
                    VStack {
                        HStack {
                            Text("Contact Support")
                                .font(.IBMMedium(size: 16))
                                .foregroundStyle(.darkGrey)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundStyle(.darkGrey)
                        }
                        Divider().padding([.bottom],5)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                       
                    }
                    
                
                NavigationLink(value: Route.about) {
                    VStack {
                        HStack {
                            Text("About")
                                .font(.IBMMedium(size: 16))
                                .foregroundStyle(.darkGrey)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundStyle(.darkGrey)
                        }
                       
                    }
                    
                }
            }
            .padding()
            .modifier(CustomCard())
            .padding()
            
            
            Spacer()
        }
        .navigationTitle("Settings")
        
    }
}

#Preview {
    SettingsView(viewModel: SettingsViewModel(appNavigation: AppNavigation()))
}
