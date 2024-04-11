//
//  StatsView.swift
//  MeCheck
//
//  Created by Robert Mutai on 26/02/2024.
//

import SwiftUI

struct StatsView: View {
    @ObservedObject var viewModel: StatsViewModel
    @State private var currentSegment = 1
    @State private var menuPeriod: String = "Monthly"
    @State private var menuStatistic: String = "Mood"
//    @Binding var selectedPeriod: Frequency
//    @Binding var dateFormatter: DateFormatter
//    @Binding var date: Date
    
    var body: some View {
        VStack {
            CustomHeader(selectedPeriod: $viewModel.selectedPeriod, date: $viewModel.date)
            Spacer()
                .frame(height: 20)
            HStack {
               
                VStack(alignment: .leading) {
                    Text("Statistic")
                        .font(.IBMRegular(size: 14))
                    Menu {
                        ForEach(viewModel.segments, id: \.self) { segment in
                            Button(action: {
                                menuStatistic = segment.title
                            }) {
                                HStack {
                                    Image(segment.icon, bundle: .none)
                                    Text(segment.title)
                                        .font(.IBMRegular(size: 15))
                                }
                            }
                        }
                        
                    } label: {
                        HStack {
                            Text(menuStatistic).font(.IBMSemiBold(size: 15))
                            Image(systemName: "arrowtriangle.down.circle")
                        }
                        .padding(10)
                        .overlay(content: { RoundedRectangle(cornerRadius: 10.0, style: .circular)
                            .strokeBorder(.lightGrey)})
                        
                    }.tint(.darkGrey)
                        
                    
                }
                
                Spacer().frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                    
                VStack(alignment: .leading) {
                    Text("Period")
                        .font(.IBMRegular(size: 14))
                    Menu {
                        ForEach(viewModel.period, id: \.self) { item in
                            
                            Button(action: {
                                menuPeriod = item
                                if item == "Monthly"{
                                    viewModel.selectedPeriod = .monthly
                                    
                                } else {
                                    viewModel.selectedPeriod = .yearly
                                }
                                
                            }) {
                                HStack {
                                    Text(item)
                                        .font(.IBMRegular(size: 15))
                                }
                            }
                        }
                        
                    } label: {
                        HStack {
                            Text(menuPeriod)
                                .font(.IBMSemiBold(size: 15))
                            Image(systemName: "arrowtriangle.down.circle")
                        }
                        .padding(10)
                        .overlay(content: { RoundedRectangle(cornerRadius: 10.0, style: .circular)
                            .strokeBorder(.lightGrey)})
                        
                    }.tint(.darkGrey)
                    
                }
               
        }
            Divider()
                .padding([.leading,.trailing])
            Text(LocalizedStringKey(stringLiteral: viewModel.title))
                .font(.IBMMedium(size: 15))
            Divider()
                .padding([.leading,.trailing])
            Spacer()
            
            if menuStatistic == "Mood" {
                MoodStatsView(viewModel: MoodStatsViewModel(selectedPeriod: viewModel.selectedPeriod, date: viewModel.date))
                
            } else if menuStatistic == "Habits" {
                HabitStatsView(viewModel: HabitStatsViewModel(selectedPeriod: viewModel.selectedPeriod, date: viewModel.date))
                
            } else if menuStatistic == "Gratitude" {
                GratitudeStatsView(viewModel: GratitudeStatsViewModel(selectedPeriod: viewModel.selectedPeriod, date: viewModel.date))
            }
            
        }
//        .onAppear(perform: {
//            date = Date()
//            selectedPeriod = .monthly
//            dateFormatter.dateFormat = "MMMM, YYYY"
//        })
        
    }
}

#Preview {
    StatsView(viewModel: StatsViewModel())
}
