//
//  MoodView.swift
//  MeCheck
//
//  Created by Robert Mutai on 26/02/2024.
//

import SwiftUI
import Charts
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
            Text(viewModel.moodLabel)
            
            moodOptionsSection
            if viewModel.moodChartData.count > 0 {
                chartsSection
            }
            
        }
        .padding([.leading,.trailing],10)
        
    }
}

private extension MoodView {
    var moodOptionsSection: some View {
        VStack {
            MoodRow(dayImage: "wb_twilight", dayLabel: "Morning", feeling: $viewModel.moodItem.morning)
                .padding([.leading, .top, .trailing])
                .sheet(isPresented: $viewModel.showSheet, content: {
                    moodSelectSection
                })
                .onTapGesture {
                    viewModel.timeDaySelected = .morning
                    viewModel.showSheet = true
                 }
            
            MoodRow(dayImage: "clear_day", dayLabel: "Afternoon", feeling: $viewModel.moodItem.afternoon)
                .padding()
                .sheet(isPresented: $viewModel.showSheet, content: {
                    moodSelectSection
                })
                .onTapGesture {
                    viewModel.timeDaySelected = .afternoon
                    viewModel.showSheet = true
                 }
            
            MoodRow(dayImage: "clear_night", dayLabel: "Evening", feeling: $viewModel.moodItem.evening)
                .padding([.leading, .bottom, .trailing])
                .sheet(isPresented: $viewModel.showSheet, content: {
                    moodSelectSection
                })
                .onTapGesture {
                    viewModel.timeDaySelected = .evening
                    viewModel.showSheet = true
                 }
        }
        .overlay(RoundedRectangle(cornerRadius: 10.0, style: .circular)
            .strokeBorder(.quaternary))
    }
}
private extension MoodView {
    var moodSelectSection: some View {
         VStack {
             HStack{
                 Spacer()
                 Text(viewModel.timeDaySelected.rawValue)
                     .bold()
                     .font(.system(size: 20))
                 Spacer()
                 Image("close", bundle: .none)
                     .resizable()
                     .frame(width: 16, height: 16)
                     .foregroundStyle(.secondary)
                     .padding()
                     .background(.quinary,in: RoundedRectangle(cornerRadius: 20, style: .circular))
                     .onTapGesture {
                         viewModel.showSheet = false
                     }
             }.padding([.top,.trailing,.leading])
             
             
             HStack {
                 VStack {
                     Text(MoodEmoji.great.rawValue)
                         .font(.system(size: 50))
                     Text("great")
                 }.onTapGesture {
                     viewModel.showSheet = false
                     viewModel.saveMood(feeling: MoodEmoji.great.rawValue)
                 }
                 
                 VStack {
                     Text(MoodEmoji.good.rawValue)
                         .font(.system(size: 50))
                     Text("good")
                 }.onTapGesture {
                     viewModel.showSheet = false
                     viewModel.saveMood(feeling: MoodEmoji.good.rawValue)
                 }
                 
                 VStack {
                     Text(MoodEmoji.okay.rawValue)
                         .font(.system(size: 50))
                     Text("okay")
                 }.onTapGesture {
                     viewModel.showSheet = false
                     viewModel.saveMood(feeling: MoodEmoji.okay.rawValue)
                 }
                 
                 VStack {
                     Text(MoodEmoji.sad.rawValue)
                         .font(.system(size: 50))
                     Text("sad")
                 }.onTapGesture {
                     viewModel.showSheet = false
                     viewModel.saveMood(feeling: MoodEmoji.sad.rawValue)
                 }
                 
                 VStack {
                     Text(MoodEmoji.awful.rawValue)
                         .font(.system(size: 50))
                     Text("awful")
                 }.onTapGesture {
                     viewModel.showSheet = false
                     viewModel.saveMood(feeling: MoodEmoji.awful.rawValue)
                 }
                     
             }.padding([.bottom, .trailing, .leading])
         }.presentationDetents([.height(200)])
    }
}
private extension MoodView {
    var chartsSection: some View {
        VStack{
            HStack{
                Spacer()
                Text("Mood Graph")
                    .font(.system(size: 16))
                Spacer()
            }.padding([.top,.trailing,.leading])
            
            Chart(viewModel.moodChartData) {
                LineMark(
                    x: .value("Time of Day", $0.timeOfDay),
                    y: .value("Mood", $0.mood)
                ).interpolationMethod(.monotone)
                
            }.chartYScale(domain: viewModel.moodData)
        }.frame(width: 320,height: 200)
    }
}

#Preview {
    MoodView(viewModel: MoodViewModel(quoteItem: .none, date: Date()))
}
