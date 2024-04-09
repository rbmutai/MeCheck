//
//  HomeView.swift
//  MeCheck
//
//  Created by Robert Mutai on 23/02/2024.
//

import SwiftUI
import Combine
struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    @StateObject private var appNavigation: AppNavigation = AppNavigation()
    @State  var selectedTab : Int = 1
    var body: some View {
        NavigationStack(path: $appNavigation.navigationPath) {
            
        headerSection
            
        TabView(selection: $selectedTab) {
            MoodView(viewModel: MoodViewModel(quoteItem: viewModel.quoteItem, date: viewModel.date), selectedPeriod: $viewModel.selectedPeriod, dateFormatter: $viewModel.dateFormatter, date: $viewModel.date).tabItem {
                VStack{
                    Image("mindfulness", bundle: .none)
                    Text("Mood")
                }
            }.tag(1)
            HabitView(viewModel: HabitViewModel(date: viewModel.date), selectedTab: $selectedTab, date: $viewModel.date, selectedPeriod: $viewModel.selectedPeriod, dateFormatter: $viewModel.dateFormatter).tabItem {
                VStack{
                    Image("rule", bundle: .none)
                    Text("Habits")
                }
            }.tag(2)
            GratitudeView(viewModel: GratitudeViewModel(date: viewModel.date), selectedTab: $selectedTab, date: $viewModel.date, selectedPeriod: $viewModel.selectedPeriod, dateFormatter: $viewModel.dateFormatter).tabItem {
                VStack{
                    Image("person_celebrate", bundle: .none)
                    Text("Gratitude")
                }
            }.tag(3)
            StatsView(viewModel: StatsViewModel(), selectedPeriod: $viewModel.selectedPeriod, dateFormatter: $viewModel.dateFormatter, date: $viewModel.date).tabItem {
                VStack {
                    Image("monitoring", bundle: .none)
                    Text("Stats")
                }
            }.tag(4)
        }
            
    }
        
 }
    
}

private extension HomeView {
    var headerSection: some View {
        HStack {
            Image("person", bundle: .none)
              .resizable()
              .frame(width: 20, height: 20)
              .foregroundStyle(.secondary)
              .padding()
              .background(.quinary,in: RoundedRectangle(cornerRadius: 10.0, style: .circular))
              .padding()
              .onTapGesture {
                  
              }
            
            Spacer()
            
            Image("first_page", bundle: .none)
              .resizable()
              .frame(width: 16, height: 16)
              .foregroundStyle(.gray)
              .onTapGesture {
                  viewModel.updateDate(by: -1)
              }
            Text(viewModel.dateLabel)
                .bold()
                .frame(width: 130).font(.IBMSemiBold(size: 16))
                
            Image("last_page", bundle: .none)
              .resizable()
              .frame(width: 16, height: 16)
              .foregroundStyle(.gray)
              .onTapGesture {
                  viewModel.updateDate(by: 1)
            }
            
            Spacer()
            
            Image("calendar_month", bundle: .none)
              .resizable()
              .frame(width: 20, height: 20)
              .foregroundStyle(.secondary)
              .padding()
              .background(.quinary,in: RoundedRectangle(cornerRadius: 10.0, style: .circular))
              .padding()
              .onTapGesture {
                  viewModel.showSheet = true
              }
            
        }
        .frame(height: 40)
        .sheet(isPresented: $viewModel.showSheet, content: {
            calendarSection
        })
        
    }
    
}

private extension HomeView {
    var calendarSection: some View {
        VStack {
            HStack {
                Spacer()
                CloseImage()
                    .onTapGesture {
                        viewModel.showSheet = false
                    }
            }
            .padding([.top], 16)
            
           
                if #available(iOS 17.0, *) {
                DatePicker("", selection: $viewModel.date, displayedComponents: [.date])
                    .datePickerStyle(.graphical)
                    .onChange(of: viewModel.date) { oldValue, newValue in
                        viewModel.showSheet = false
                    }
                } else {
                    // Fallback on earlier versions
                    DatePicker("", selection: $viewModel.date, displayedComponents: [.date])
                        .datePickerStyle(.graphical)
                        .onChange(of: viewModel.date) { _ in
                            viewModel.showSheet = false
                        }
                }
            }
            .padding()
            .presentationDetents([.medium])
        
        }
}

#Preview {
    HomeView(viewModel: HomeViewModel(), selectedTab: 1)
}
