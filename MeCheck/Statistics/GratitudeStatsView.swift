//
//  GratitudeStatsView.swift
//  MeCheck
//
//  Created by Robert Mutai on 10/04/2024.
//

import SwiftUI
import Charts
struct GratitudeStatsView: View {
    @ObservedObject var viewModel: GratitudeStatsViewModel
    @EnvironmentObject private var entitlementManager: EntitlementManager
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Text("Good things that happened")
                        .font(.IBMMedium(size: 15))
                        
                    Text("\(viewModel.gratitudeData.count)")
                        .font(.IBMMedium(size: 30))
                        .lineLimit(1)
                        .padding(25)
                        .overlay(content: {
                            Circle()
                                .stroke(.purple, lineWidth: 2)
                                .padding(1)
                        }).frame(width: 150)
                    Spacer()
                }
                
                HStack {
                    Text("Who was responsible")
                        .font(.IBMMedium(size: 16))
                    Spacer()
                }
                
                if viewModel.responsibleData.count>0 {
                    ResponsibleViewSection
                } else {
                    EmptyResponsibleViewSection
                        .opacity(0.17)
                        .overlay {
                            Text("No data currently available")
                                .font(.IBMRegular(size: 14))
                        }
                }
                
                HStack {
                    Text("How did it make you feel")
                        .font(.IBMMedium(size: 16))
                    Spacer()
                }.padding([.top])
                
                if viewModel.feelingData.count>0{
                    FeelingViewSection
                } else {
                    EmptyFeelingViewSection
                        .opacity(0.17)
                        .overlay {
                            Text("No data currently available")
                                .font(.IBMRegular(size: 14))
                        }
                }
                
                
            }.padding()
        }
    }
}

private extension GratitudeStatsView {
    var ResponsibleViewSection: some View {
        VStack {
            Chart(Array(viewModel.responsibleData).sorted(by: { $0.value > $1.value }), id: \.key) { key, value in
                BarMark(x: .value("Type", value),
                        y: .value("Type", key))
                .foregroundStyle(by: .value("Type", key))
                .annotation(position: .trailing) {
                                Text(String(value))
                                    .font(.IBMRegular(size: 14))
                            }
            }
            .chartLegend(.hidden)
            .chartXAxis(.hidden)
            .chartYAxis {
                AxisMarks { value in
                    AxisValueLabel()
                        .font(.IBMRegular(size: 15))
//                        AxisValueLabel {
//                            if let title = value.as(String.self) {
//                                Text(title)
//                                    .font(.system(size: 14))
//                                    .frame(width: 50)
//                                    .lineLimit(3)
//                                    .minimumScaleFactor(0.5)
//
//
//                            }
//                        }
                }
            }
            .aspectRatio(contentMode: .fill)
            .padding([.leading,.trailing,.bottom])
        }.padding(10)
         .modifier(CustomCard())
         .opacity(entitlementManager.hasPro ? 1 : 0.15)
         .overlay {
             if !entitlementManager.hasPro {
                 PremiumContentView()
             }
         }
    }
}
private extension GratitudeStatsView {
    var EmptyResponsibleViewSection: some View {
        VStack{
            Chart(Array(viewModel.emptyResponsibleData).sorted(by: { $0.value > $1.value }), id: \.key) { key, value in
                BarMark(x: .value("Type", value),
                        y: .value("Type", key))
                .foregroundStyle(by: .value("Type", key))
                .annotation(position: .trailing) {
                                Text(String(value))
                                    .font(.IBMRegular(size: 14))
                            }
            }
            .chartLegend(.hidden)
            .chartXAxis(.hidden)
            .chartYAxis {
                AxisMarks { value in
                    AxisValueLabel()
                        .font(.IBMRegular(size: 15))
                }
            }
            .aspectRatio(contentMode: .fill)
            .padding([.leading,.trailing,.bottom])
        }
    }
}
private extension GratitudeStatsView {
    var FeelingViewSection: some View {
        VStack {
            if #available(iOS 17.0, *) {
                Chart(Array(viewModel.feelingData), id: \.key) { key, value in
                    SectorMark(angle: .value("Type", value), angularInset: 2)
                    .cornerRadius(5)
                    .foregroundStyle(by: .value("Type", key))
                    .annotation(position: .overlay) {
                        HStack{
                            Text("\(key)")
                                .font(.IBMRegular(size: 18))
                            Text("\(value)")
                                .font(.IBMRegular(size: 15))
                                .foregroundStyle(.white)
                        }
                    }
                }
                .frame(height: 250)
                .chartLegend(.hidden)
                .padding([.leading,.trailing,.bottom])
                
            } else {
                // Fallback on earlier versions
                Chart(Array(viewModel.feelingData), id: \.key) { key, value in
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
                .padding([.leading,.trailing,.bottom])

            }
        }.padding(10)
         .modifier(CustomCard())
         .opacity(entitlementManager.hasPro ? 1 : 0.15)
         .overlay {
             if !entitlementManager.hasPro {
                 PremiumContentView()
             }
         }
    }
}
private extension GratitudeStatsView {
    var EmptyFeelingViewSection: some View {
        VStack {
            if #available(iOS 17.0, *) {
                Chart(Array(viewModel.emptyFeelingData), id: \.key) { key, value in
                    SectorMark(angle: .value("Type", value), angularInset: 2)
                    .cornerRadius(5)
                    .foregroundStyle(by: .value("Type", key))
                    .annotation(position: .overlay) {
                        HStack{
                            Text("\(key)")
                                .font(.IBMRegular(size: 20))
                            Text("\(value)")
                                .font(.IBMRegular(size: 15))
                                .foregroundStyle(.white)
                        }
                    }
                }
                .frame(height: 250)
                .chartLegend(.hidden)
                
            } else {
                // Fallback on earlier versions
                Chart(Array(viewModel.emptyFeelingData), id: \.key) { key, value in
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
    }
}

#Preview {
    GratitudeStatsView(viewModel: GratitudeStatsViewModel(selectedPeriod: .monthly, date: Date()))
        .environmentObject(EntitlementManager())
}
