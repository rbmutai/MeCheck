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
                        .overlay(RoundedRectangle(cornerRadius: 10.0, style: .circular)
                            .strokeBorder(.quaternary))
                        
                    }.tint(.darkGrey)
                        
                    
                }
                
                Spacer().frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                    
                VStack(alignment: .leading) {
                    Text("Period")
                        .font(.IBMRegular(size: 14))
                    Menu {
                        ForEach(viewModel.period, id: \.self) { period in
                            
                            Button(action: {
                                viewModel.updateSelectedPeriod(selected: period)
                            }) {
                                HStack {
                                    Text(period)
                                        .font(.IBMRegular(size: 15))
                                }
                            }
                        }
                        
                    } label: {
                        HStack {
                            Text(viewModel.selectedPeriod)
                                .font(.IBMSemiBold(size: 15))
                            Image(systemName: "arrowtriangle.down.circle")
                        }
                        .padding(10)
                        .overlay(RoundedRectangle(cornerRadius: 10.0, style: .circular)
                            .strokeBorder(.quaternary))
                        
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
        }
        
    }
}

#Preview {
    StatsView(viewModel: StatsViewModel())
}
