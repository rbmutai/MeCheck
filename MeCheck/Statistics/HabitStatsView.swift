//
//  HabitStatsView.swift
//  MeCheck
//
//  Created by Robert Mutai on 10/04/2024.
//

import SwiftUI
import Charts
struct HabitStatsView: View {
    @ObservedObject var viewModel: HabitStatsViewModel
    var body: some View {
        ScrollView {
            VStack{
                VStack {
                    if viewModel.habitData.isEmpty {
                        EmptyStatsView
                            .opacity(0.5)
                            .blur(radius: 5)
                            .overlay {
                                Text("No Data Available")
                                    .font(.IBMRegular(size: 14))
                            }
                        
                    } else {
                        ForEach(viewModel.habitData) { item in
                            HStack {
                                Text(item.image)
                                    .font(.system(size: 20))
                                    .padding(8)
                                    .background(Color(item.backgroundColor, bundle: .main),in: RoundedRectangle(cornerRadius: 10.0, style: .circular))
                                Text(item.title)
                                    .font(.IBMMedium(size: 15))
                                
                                Spacer()
                            }
                            
                            VStack{
                                HStack {
                                    Text("Count")
                                        .font(.IBMRegular(size: 14))
                                    
                                    Text("\(item.trackCount)")
                                        .font(.IBMMedium(size: 15))
                                   
                                    Spacer()
                                }
                               
                                HStack {
                                    Text("Completion")
                                        .font(.IBMRegular(size: 14))
                                    
                                    Text("\(item.completion)")
                                        .font(.IBMMedium(size: 15))
                                   
                                    Spacer()
                                }
                                
                                 HStack {
                                     Text("Longest streak")
                                         .font(.IBMRegular(size: 14))
                                     
                                     Text("\(item.streak)")
                                         .font(.IBMMedium(size: 15))
                                    
                                     Spacer()
                                 }
                               
                                
                            }
                           
                            HStack {
                                Text("Frequency Chart")
                                    .font(.IBMMedium(size: 14))
                                Spacer()
                            }.padding([.top],8)
                            
                            Chart(item.trackDates, id: \.self) { itemDates in
                                BarMark(x: .value("Date", itemDates, unit: .day),
                                        y: .value("Type", 1), width: 6)
                               
                            }
                            .frame(height: 80)
                            .chartYAxis(.hidden)
                            .chartXAxis {
                                AxisMarks(position: .bottom, values: .stride(by: .day, count: 1)) { _ in
                                    AxisGridLine()
                                    AxisValueLabel(format: .dateTime.day(), anchor: .top)
                                }
                            }
                            
                        }
                    }
                }.padding()
            }
        }
    }
}

extension HabitStatsView {
    var EmptyStatsView : some View {
        VStack{
            HStack {
                Text(viewModel.emptyData.image)
                    .font(.system(size: 20))
                    .padding(8)
                    .background(Color(viewModel.emptyData.backgroundColor, bundle: .main),in: RoundedRectangle(cornerRadius: 10.0, style: .circular))
                Text(viewModel.emptyData.title)
                    .font(.IBMMedium(size: 15))
                
                   
                Spacer()
            }
            
            VStack{
                HStack {
                    Text("Count")
                        .font(.IBMRegular(size: 14))
                    
                    Text("\(viewModel.emptyData.trackCount)")
                        .font(.IBMMedium(size: 15))
                   
                    Spacer()
                }
               
                HStack {
                    Text("Longest streak")
                        .font(.IBMRegular(size: 14))
                    
                    Text("\(viewModel.emptyData.streak)")
                        .font(.IBMMedium(size: 15))
                   
                    Spacer()
                }
              
                HStack {
                    Text("Completion")
                        .font(.IBMRegular(size: 14))
                    
                    Text("\(viewModel.emptyData.completion)")
                        .font(.IBMMedium(size: 15))
                   
                    Spacer()
                }
               
                
            }
            HStack{
                Text("Frequency Chart")
                    .font(.IBMMedium(size: 14))
                Spacer()
            }.padding([.top],8)
            
            Chart(viewModel.emptyData.trackDates, id: \.self) { itemDates in
                BarMark(x: .value("Date", itemDates, unit: .day),
                        y: .value("Type", 1), width: 6)
               
            }
            .frame(height: 80)

            .chartXAxis {
                AxisMarks(position: .bottom, values: .stride(by: .day, count: 1)) { _ in
                    AxisGridLine()
                    AxisValueLabel(format: .dateTime.day(), anchor: .top)
                }
            }
        }
        
    }
}

#Preview {
    HabitStatsView(viewModel: HabitStatsViewModel(selectedPeriod: .monthly, date: Date()))
}
