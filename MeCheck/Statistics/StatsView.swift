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
                                viewModel.updateSelectedSegment(id: segment.id)
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
                            Text(viewModel.selectedSegment).font(.IBMSemiBold(size: 15))
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
                                if item == "Monthly"{
                                    viewModel.selectedPeriod = .monthly
                                } else {
                                    viewModel.selectedPeriod = .yearly
                                }
                                viewModel.updateSelectedPeriod(selected: item)
                                
                            }) {
                                HStack {
                                    Text(item)
                                        .font(.IBMRegular(size: 15))
                                }
                            }
                        }
                        
                    } label: {
                        HStack {
                            Text(viewModel.selectedDataPeriod)
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
            
            if viewModel.selectedSegment == "Mood" {
                MoodStatsView(viewModel: MoodStatsViewModel(selectedPeriod: viewModel.selectedPeriod, date: viewModel.date))
                
            } else if viewModel.selectedSegment == "Habits" {
                HabitStatsView(viewModel: HabitStatsViewModel(selectedPeriod: viewModel.selectedPeriod, date: viewModel.date))
                
            } else if viewModel.selectedSegment == "Gratitude" {
                GratitudeStatsView(viewModel: GratitudeStatsViewModel(selectedPeriod: viewModel.selectedPeriod, date: viewModel.date))
            }
            
        }
    }
}

#Preview {
    StatsView(viewModel: StatsViewModel())
}
