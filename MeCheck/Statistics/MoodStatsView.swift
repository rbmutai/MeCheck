//
//  MoodStatsView.swift
//  MeCheck
//
//  Created by Robert Mutai on 10/04/2024.
//

import SwiftUI
import Charts
struct MoodStatsView: View {
    @ObservedObject var viewModel: MoodStatsViewModel
    let chartColors: [String: Color] = ["😀": Color.green,"🙂": Color.orange,"😐": Color.blue,"🙁": Color.red,"😣": Color.purple]
    var body: some View {
        ScrollView {
            VStack{
                //Mood Graph
                VStack {
                    HStack {
                        Text("Mood Graph")
                            .font(.IBMMedium(size: 16))
                        Spacer()
                    }
                    
                    if viewModel.moodData.count == 0 {
                        EmptyMoodGraphViewSection
                    } else {
                        MoodGraphViewSection
                    }
                    
                }.padding()
                
                //Top Mood
                VStack {
                    HStack{
                        Text("Mood Count")
                            .font(.IBMMedium(size: 16))
                        Spacer()
                    }
                    if Array(viewModel.moodCountDictionary).count == 0 {
                        EmptyMoodCountViewSection
                    } else {
                        MoodCountViewSection
                    }
                    
                }
                .padding()
                
                //Best Time of Day
                VStack {
                    HStack{
                        Text("Best Time of Day")
                            .font(.IBMMedium(size: 16))
                        Spacer()
                    }
                    if Array(viewModel.bestTimeOfDayDictionary).count == 0 {
                        EmptyBestTimeOfDayViewSection
                    } else {
                        BestTimeOfDayViewSection
                    }
                    
                }
                .padding()
                
            }
            
           
            
        }
    }
}
private extension MoodStatsView {
    var MoodGraphViewSection: some View {
        VStack{
            HStack{
                Menu {
                    ForEach(viewModel.timeOfDayAll, id: \.self) { item in
                        
                        Button(action: {
                            viewModel.updateTimeOfDay(item:  item)
                        }) {
                            Text(item)
                                    .font(.IBMRegular(size: 14))
                        }
                    }
                    
                } label: {
                    HStack {
                        Text(viewModel.selectedTimeOfDay)
                            .font(.IBMSemiBold(size: 14))
                        Image(systemName: "arrowtriangle.down.circle")
                    }
                    .padding(8)
                    .overlay(content: { RoundedRectangle(cornerRadius: 10.0, style: .circular)
                        .strokeBorder(.lightGrey)})
                    
                }.tint(.darkGrey)
            }
            
            if (viewModel.selectedTimeOfDay == viewModel.timeOfDayAll[0]) {
                
            Chart(viewModel.timeOfDay, id: \.self) { dataSeries in
                ForEach(viewModel.moodData.sorted(by: {$0.date > $1.date}), id: \.self) { data in
                    LineMark(
                        x: .value("Time of Day", data.date),
                        y: .value("Mood", dataSeries == viewModel.timeOfDay[0] ?  data.morning : dataSeries == viewModel.timeOfDay[1] ? data.afternoon : data.evening )
                    )
                    .interpolationMethod(.monotone)
                    .mask {
                        RectangleMark(xStart: 35)
                        }
                }
                .foregroundStyle(by: .value("Time of Day", dataSeries))
                .symbol(by: .value("Time of Day", dataSeries))
                
                
            }
            .frame(height: 220)
            .chartXAxis {
                AxisMarks(position: .bottom, values: .stride(by: .day, count: 3)) { _ in
                    AxisGridLine()
                    AxisValueLabel(format: .dateTime.day(), anchor: .top)
                }
            }
            .chartYAxis {
                AxisMarks {
                    AxisValueLabel()
                        .font(.system(size: 25))
                }
            }
            .chartYScale(domain: viewModel.moodYData)
           
                
            } else {
                Chart(viewModel.moodData.sorted(by: {$0.date > $1.date}), id: \.self) { item in
                    LineMark(
                        x: .value("Time of Day", item.date),
                        y: .value("Mood", viewModel.selectedTimeOfDay == viewModel.timeOfDay[0] ?  item.morning : viewModel.selectedTimeOfDay == viewModel.timeOfDay[1] ? item.afternoon : item.evening )
                    )
                    .interpolationMethod(.monotone)
                    .mask {
                        RectangleMark(xStart: 35)
                    }
                   
                }
                .frame(height: 200)
                .chartXAxis {
                    AxisMarks(position: .bottom, values: .stride(by: .day, count: 3)) { _ in
                        AxisGridLine()
                        AxisValueLabel(format: .dateTime.day(), anchor: .top)
                    }
                }
                .chartYAxis {
                    AxisMarks {
                        AxisValueLabel()
                            .font(.system(size: 25))
                    }
                }
                .chartYScale(domain: viewModel.moodYData)
                
                
            }
        }
         .padding(10)
         .modifier(CustomCard())
    }
}
private extension MoodStatsView {
    var EmptyMoodGraphViewSection: some View {
        VStack{
            Chart(Array(viewModel.emptyData), id: \.key) { key, value in
                LineMark(
                    x: .value("Time of Day", value),
                    y: .value("Mood", key)
                )
                .interpolationMethod(.monotone)
            }.chartYScale(domain: viewModel.moodYData)
            .frame(height: 200)
            .chartLegend(.hidden)
            .opacity(0.8)
            .blur(radius: 5)
            .overlay {
                Text("No Data Available")
                    .font(.IBMRegular(size: 14))
            }
        }
    }
}
private extension MoodStatsView {
    var MoodCountViewSection: some View {
        VStack{
            if #available(iOS 17.0, *) {
                Chart(Array(viewModel.moodCountDictionary), id: \.key) { key, value in
                    SectorMark(angle: .value("Type", value),
                               innerRadius: .ratio(0.55),
                               angularInset: 1.5)
                    .cornerRadius(5)
                    .foregroundStyle(by: .value("Type", key))
                    .annotation(position: .overlay) {
                        Text("\(value)")
                            .font(.IBMRegular(size: 14))
                            .foregroundStyle(.white)
                        
                    }
                }
                .frame(height: 250)
                .chartBackground { _ in
                    VStack {
                        
                        Text(viewModel.topMoodLabel)
                            .font(.IBMRegular(size: 14))
                        
                        Text(viewModel.topMood)
                            .font(.system(size: 24))
                        
                    }.padding([.trailing], 55)
                }
                .chartForegroundStyleScale([
                    "😀": Color.green,
                    "🙂": Color.orange,
                    "😐": Color.blue,
                    "🙁": Color.red,
                    "😣": Color.purple
                ])
                .chartLegend(position: .trailing, alignment: .top) {
                    VStack {
                        ForEach(Array(viewModel.moodCountDictionary), id: \.key) { key, value in
                            HStack {
                                BasicChartSymbolShape.circle
                                    .foregroundColor(chartColors[key])
                                    .frame(width: 10, height: 10)
                                Text(key).font(.system(size: 25))
                            }
                        }
                    }
                    
                }
                
            } else {
                // Fallback on earlier versions
                HStack {
                    Spacer()
                    Text(viewModel.topMoodLabel)
                        .font(.IBMRegular(size: 14))
                    
                    Text(viewModel.topMood)
                        .font(.system(size: 24))
                    Spacer()
                }
                
                Chart(Array(viewModel.moodCountDictionary), id: \.key) { key, value in
                    BarMark(x: .value("Type", key),
                            y: .value("Type", value))
                    .foregroundStyle(by: .value("Type", key))
                    .annotation(position: .top) {
                                    Text(String(value))
                                        .font(.IBMRegular(size: 14))
                                }
                    
                }
                .frame(height: 200)
                .chartLegend(.hidden)
                .chartYAxis(.hidden)
                .chartXAxis {
                    AxisMarks {
                        AxisValueLabel()
                            .font(.system(size: 25))
                    }
                }

            }
        }
        .padding(10)
        .modifier(CustomCard())
    }
}
private extension MoodStatsView {
    var EmptyMoodCountViewSection: some View {
        VStack{
            if #available(iOS 17.0, *) {
                Chart(Array(viewModel.emptyData), id: \.key) { key, value in
                    SectorMark(angle: .value("Type", value),
                               innerRadius: .ratio(0.55),
                               angularInset: 1.5)
                    .cornerRadius(5)
                    .foregroundStyle(by: .value("Type", key))
                    .annotation(position: .overlay) {
                        Text("\(value)")
                            .font(.IBMRegular(size: 14))
                            .foregroundStyle(.white)
                        
                    }
                }
                .frame(height: 250)
                .chartLegend(.hidden)
                .opacity(0.3)
                .blur(radius: 10)
                .overlay {
                    Text("No Data Available")
                        .font(.IBMRegular(size: 14))
                }
                
                
            } else {
                // Fallback on earlier versions
                
                Chart(Array(viewModel.emptyData), id: \.key) { key, value in
                    BarMark(x: .value("Type", key),
                            y: .value("Type", value))
                    .foregroundStyle(by: .value("Type", key))
                    
                }
                .frame(height: 200)
                .chartLegend(.hidden)
                .opacity(0.5)
                .blur(radius: 5)
                .overlay {
                    Text("No Data Available")
                        .font(.IBMRegular(size: 14))
                }
                   
            }
        
        }
    }
}
private extension MoodStatsView {
    var BestTimeOfDayViewSection: some View {
        VStack {
            Text(viewModel.bestTimeOfDay)
                .font(.IBMRegular(size: 14))
            Chart(Array(viewModel.bestTimeOfDayDictionary), id: \.key) { key, value in // Get the values.
                BarMark(
                    x: .value("percent", value)
                )
                .foregroundStyle(by: .value("Product Category", key))
                .annotation(position: .overlay) {
                    Text(String(format: "%.0f", value)+"%")
                        .font(.IBMRegular(size: 14))
                        .foregroundStyle(.white)
                }
            }.frame(height: 80)
            .chartXScale(domain: 0...100)
        }.padding(10)
         .modifier(CustomCard())
    }
}
private extension MoodStatsView {
    var EmptyBestTimeOfDayViewSection: some View {
        VStack {
           
            Chart(Array(viewModel.emptyTimeOfDayData), id: \.key) { key, value in // Get the values.
                BarMark(
                    x: .value("percent", value)
                )
                .foregroundStyle(by: .value("Product Category", key))
                .annotation(position: .overlay) {
                    Text(String(format: "%.0f", value)+"%")
                        .font(.IBMRegular(size: 14))
                        .foregroundStyle(.white)
                }
            }
            .frame(height: 80)
            .chartLegend(.hidden)
            .opacity(0.5)
            .blur(radius: 5)
            .overlay {
                Text("No Data Available")
                    .font(.IBMRegular(size: 14))
            }
        }
    }
}

#Preview {
    MoodStatsView(viewModel: MoodStatsViewModel(selectedPeriod: .monthly, date: Date()))
}
