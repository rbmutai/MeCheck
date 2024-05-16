//
//  MoreView.swift
//  MeCheck
//
//  Created by Robert Mutai on 26/02/2024.
//

import SwiftUI
import MessageUI
import StoreKit
struct SettingsView: View {
    @ObservedObject var viewModel: SettingsViewModel
    @AppStorage("darkModeOn") var darkModeOn: Bool = false
    @State var email:String = "introspecttechnologies@gmail.com"
    @Environment(\.requestReview) var requestReview
    @EnvironmentObject private var entitlementManager: EntitlementManager
   
    var body: some View {
        ScrollView {
        VStack {
            NavigationLink(value: Route.subscriptions) {
                HStack {
                    if entitlementManager.hasPro {
                        Image(systemName: "crown.fill")
                            .foregroundStyle(.yellow)
                    }
                    Text("\(entitlementManager.hasPro ? viewModel.premiumLabel : viewModel.freeLabel)")
                        .font(.IBMMedium(size: 16))
                        .foregroundStyle(.darkGrey)
                    
                    Spacer()
                    
                    if !entitlementManager.hasPro {
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
                Text("Dark Mode")
                    .font(.IBMMedium(size: 16))
                    .foregroundStyle(.darkGrey)
                Toggle("", isOn: $darkModeOn)
                Spacer()
            }
            .padding()
            .modifier(CustomCard())
            .padding()
            
            VStack {
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
                    requestReview()
                }
                
                VStack {
                    HStack {
                    ShareLink(item: viewModel.shareInfo) {
                         Text("Share with a Friend")
                            .font(.IBMMedium(size: 16))
                            .foregroundStyle(.darkGrey)
                         Spacer()
                         Image(systemName: "chevron.right")
                            .foregroundStyle(.darkGrey)
                        }
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
                    
                }
                .contentShape(Rectangle())
                .onTapGesture {
                   // let emailTo = "mailto://"
//                   let emailTo = "mailto:"
//                    let emailformatted = emailTo + email
//                    guard let url = URL(string: emailformatted) else { return }
//                   
//                    UIApplication.shared.open(url, options: [.universalLinksOnly : false]) { (success) in
//                            // Handle success/failure
//                        print(success)
//                        }
                    
                    EmailService.shared.sendEmail(subject: "", body: "", to: email) { (success) in
                        print(success)
                        if !success {
                            //if mail couldn't be presented
                            // do action
                            
                        }
                    }
                }
            }
            .padding()
            .modifier(CustomCard())
            .padding()
            
            
            Spacer()
            Text("Version \(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0")")
                .font(.IBMRegular(size: 14))
                .foregroundStyle(.darkGrey)
        }
    }.navigationTitle("Settings")
        
    }
}

#Preview {
    SettingsView(viewModel: SettingsViewModel(appNavigation: AppNavigation()))
        .environmentObject(EntitlementManager())
}
