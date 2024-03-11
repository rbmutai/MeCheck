//
//  MoodView.swift
//  MeCheck
//
//  Created by Robert Mutai on 26/02/2024.
//

import SwiftUI

struct MoodView: View {
    @ObservedObject var viewModel: MoodViewModel
    var body: some View {
        ScrollView {
         Spacer(minLength: 15)
            VStack {
                    Group {
                        Text("Quote of the Day")
                        Text(viewModel.detail)
                            .bold()
                        HStack {
                            Spacer()
                            Text(viewModel.author)
                        }
                    }
                    .padding([.leading,.trailing], 18)
                    .italic()
                    .foregroundStyle(.black)
                }
                .frame(width: 350, height: 180)
                .background {
                    Image(viewModel.background, bundle: .none)
                        .resizable()
                        .frame(width: 330, height: 180, alignment: .center)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .blur(radius: 2)
                        
                }
            Spacer(minLength: 20)
                Text("How did you feel \(Calendar.current.isDateInToday(viewModel.date) ? "today" : Calendar.current.isDateInYesterday(viewModel.date) ?  "yesterday" :  viewModel.dateFormatter.string(from: viewModel.date))?")
            moodOptionsSection
        }
        .padding([.leading,.trailing],10)
        
            
    }
}
private extension MoodView {
    var moodOptionsSection: some View {
        VStack {
            HStack {
                    Image("wb_twilight", bundle: .none)
                    .resizable()
                    .frame(width: 25, height: 25)
                    .foregroundStyle(.secondary)
                    Text("Morning")
                    Spacer()
                    HStack {
                        Text("Add")
                        Image("add_circle", bundle: .none)
                    }
                    .padding([.all],10)
                    .opacity(0.7)
                    .background(.quinary,in: RoundedRectangle(cornerRadius: 10.0, style: .circular))
                        .onTapGesture {
                            
                        }
                }
                .frame(width: 250,height: 30)
                .padding([.leading,.top,.trailing])
                
            HStack {
                    Image("clear_day", bundle: .none)
                    .resizable()
                    .frame(width: 25, height: 25)
                    .foregroundStyle(.secondary)
                    Text("Afternoon")
                    Spacer()
                    HStack {
                        Text("Add")
                        Image("add_circle", bundle: .none)
                    }
                    .padding([.all],10)
                    .opacity(0.7)
                    .background(.quinary,in: RoundedRectangle(cornerRadius: 10.0, style: .circular))
                        .onTapGesture {
                            
                        }
                }
                .frame(width: 250,height: 30)
                .padding([.all])
                
            HStack {
                    Image("clear_night", bundle: .none)
                    .resizable()
                    .frame(width: 25, height: 25)
                    .foregroundStyle(.secondary)
                    Text("Evening")
                    Spacer()
                    HStack {
                        Text("Add")
                        Image("add_circle", bundle: .none)
                        
                    }
                    .padding([.all],10)
                    .opacity(0.7)
                    .background(.quinary,in: RoundedRectangle(cornerRadius: 10.0, style: .circular))
                        .onTapGesture {
                            
                        }
                }
                .frame(width: 250,height: 30)
                .padding([.leading,.bottom,.trailing])
            
        }
        .overlay(RoundedRectangle(cornerRadius: 10.0, style: .circular)
            .strokeBorder(.quaternary))
        
        
        
    }
}

#Preview {
    MoodView(viewModel: MoodViewModel(quoteItem: .none, date: Date()))
}
