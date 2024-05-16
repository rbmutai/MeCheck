//
//  GratitudeView.swift
//  MeCheck
//
//  Created by Robert Mutai on 26/02/2024.
//

import SwiftUI

struct GratitudeView: View {
    @ObservedObject var viewModel: GratitudeViewModel
    @Binding var selectedTab: Int
    @EnvironmentObject private var entitlementManager: EntitlementManager
    private var iOS17Available: Bool {
            guard #available(iOS 17, *) else {
                return false
            }
            print("Run iOS 17 and higher code.")
            return true
        }
    
    private var iOS17UnAvailable: Bool {
        if #unavailable(iOS 17) {
            // Run iOS 16 and lower code.
            print("Run iOS 16 and lower code.")
            return true
        }
        return false
    }
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack {
                CustomHeader(selectedPeriod: $viewModel.selectedPeriod, date: $viewModel.date, appNavigation: viewModel.appNavigation)
                    VStack{
                        if viewModel.gratitudes.isEmpty {
                            Text(viewModel.introMessage)
                                .multilineTextAlignment(.center)
                                .font(.IBMRegular(size: 16))
                                .padding()
                        } else {
                            if let date = viewModel.gratitudeDictionary.sorted(by: {$0.key > $1.key}).first?.key {
                                
                                if !Calendar.current.isDateInToday(date) {
                                    HStack {
                                        Text(viewModel.todayMessage)
                                            .font(.IBMRegular(size: 15))
                                            .padding([.leading], 20)
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
                                    .padding([.top],10)
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        viewModel.showSheet = true
                                    }
                                }
                            }
                            List {
                                ForEach(viewModel.gratitudeDictionary.sorted(by: {$0.key > $1.key}), id: \.key) { key, value in
                                     HStack {
                                        Spacer()
                                         Text(Calendar.current.isDateInToday(key) ? "Today" : viewModel.dayFormatter.string(from: key))
                                            .font(.IBMMedium(size: 15))
                                        Spacer()
                                     }
                                    ForEach(value.sorted(by: {$0.date > $1.date})) { item in
                                            
                                            VStack {
                                                HStack{
                                                    Text(item.icon)
                                                        .font(.system(size: 30))
                                                        .padding(3)
                                                    
                                                    Text(item.responsible)
                                                        .font(.IBMRegular(size: 15))
                                                        .padding(10)
                                                        .overlay(content: { RoundedRectangle(cornerRadius: 20, style: .circular)
                                                            .strokeBorder(.lightGrey, lineWidth: 1)})
                                                    
                                                    Spacer()
                                                    Text(item.date.formatted(date: .omitted, time: .shortened))
                                                        .font(.IBMRegular(size: 13))
                                                    
                                                }.padding([.leading,.trailing,.top],10)
                                                
                                                Divider().padding([.leading,.trailing])
                                                Text(item.detail)
                                                    .font(.IBMRegular(size: 15))
                                                    .padding([.leading,.trailing,.bottom])
                                                
                                            }.background(.shadowBackground)
                                            .overlay(content: { RoundedRectangle(cornerRadius: 10.0, style: .circular).strokeBorder( Color(HabitColors.LightGrey.rawValue, bundle: .main) , lineWidth: 1)})
                                            
                                            .swipeActions(allowsFullSwipe: false) {
                                                Button {
                                                    viewModel.editGratitude(item: item)
                                                } label: {
                                                    Label("Edit", systemImage: "square.and.pencil")
                                                }
                                                .tint(.indigo)
                                                
                                                Button(role: .destructive) {
                                                    viewModel.deleteGratitude(id: item.id)
                                                    viewModel.getGratitude()
                                                } label: {
                                                    Label("Delete", systemImage: "trash.fill")
                                                }
                                            }
                                            .contextMenu {
                                                
                                                Button {
                                                    viewModel.editGratitude(item: item)
                                                } label: {
                                                    Label("Edit", systemImage: "square.and.pencil")
                                                }
                                                
                                                Button(role: .destructive) {
                                                    viewModel.deleteGratitude(id: item.id)
                                                    viewModel.getGratitude()
                                                } label: {
                                                    Label("Delete", systemImage: "trash.fill")
                                                }
                                                
                                            }
                                            
                                        }
                                        .listRowSeparator(.hidden)
                                        .listRowBackground(Color.clear)
                                        .listRowInsets(.init(top: 7, leading: 5, bottom: 7, trailing: 5))
                                        .shadow(color:.shadow ,radius: 10)
                                        
                                       
                                }
                            }
                            .scrollContentBackground(.hidden)
                            .background(.clear)
                           
                        }
                        
                        if #available(iOS 17.0, *) {
                            Spacer().onChange(of: viewModel.date) { oldValue, newValue in
                                viewModel.getGratitude()
                            }
                        } else {
                            // Fallback on earlier versions
                            Spacer().onChange(of: viewModel.date) { _ in
                                viewModel.getGratitude()
                                
                                }
                        }
                        
                    }
            
            }
            .onAppear(perform: {
                viewModel.getGratitude()
            })
            
            Button {
                if !entitlementManager.hasPro && viewModel.gratitudes.count > 14 {
                    viewModel.showAlert = true
                } else {
                    viewModel.showSheet = true
                }
            } label: {
                Image(systemName: !entitlementManager.hasPro && viewModel.gratitudes.count > 14 ? "crown.fill" : "plus")
                    .font(.headline.weight(.semibold))
                    .padding()
                    .background(Color.purple)
                    .foregroundColor(.white)
                    .clipShape(Circle())
            }
                .padding()
                .sheet(isPresented: $viewModel.showSheet, onDismiss: {
                    selectedTab = 3
                    viewModel.getGratitude()
                }, content: {
                    if viewModel.isEdit {
                        AddGratitudeView(viewModel: AddGratitudeViewModel(gratitudeItem: viewModel.gratitudeItem, date: viewModel.date), showSheet: $viewModel.showSheet)
                        
                    } else {
                        AddGratitudeView(viewModel: AddGratitudeViewModel(date: viewModel.date), showSheet: $viewModel.showSheet)
                    }
                })
                .alert(viewModel.alertTitle, isPresented: $viewModel.showAlert) {
                    NavigationLink(value: Route.subscriptions) {
                        Button("Upgrade", action: {})
                    }
                  
                    Button("Cancel", role: .cancel, action: {})
                } message: {
                    Text(viewModel.alertMessage)
                }
        }
    }
}

#Preview {
    GratitudeView(viewModel: GratitudeViewModel(appNavigation: AppNavigation()), selectedTab: .constant(3)) .environmentObject(EntitlementManager())
}

