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
    VStack {
        CustomHeader(selectedPeriod: $viewModel.selectedPeriod, date: $viewModel.date)
        ScrollView {
            if #available(iOS 17.0, *) {
                Spacer(minLength: 15).onChange(of: viewModel.date) { oldValue, newValue in
                    viewModel.loadMood()
                }
            } else {
                // Fallback on earlier versions
                Spacer(minLength: 15).onChange(of: viewModel.date) { _ in
                    viewModel.loadMood()
                    
                    }
            }
            VStack {
                Group {
                    Text("Quote of the Day")
                        .font(.IBMRegular(size: 15))
                    Text(viewModel.detail)
                        .font(.IBMMedium(size: 16))
                    HStack {
                        Spacer()
                        Text(viewModel.author)
                            .font(.IBMRegular(size: 14))
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
                    .blur(radius: 2)
                
            }.shadow(color:.shadow ,radius: 10)
            
            Spacer(minLength: 20)
            Text(viewModel.moodLabel).font(.IBMRegular(size: 16))
            
            moodOptionsSection
            if viewModel.showChart {
                chartsSection
            }
            
        }.padding([.leading,.trailing],10)
    } .onAppear(perform: {
            viewModel.loadMood()
        })
        
        
    }
}

private extension MoodView {
    var moodOptionsSection: some View {
        VStack {
            MoodRow(dayImage: "wb_twilight", dayLabel: TimeOfDay.morning.rawValue, feeling: $viewModel.moodItem.morning)
                .padding([.leading, .top, .trailing])
                .sheet(isPresented: $viewModel.showSheet, content: {
                    moodSelectSection
                })
                .onTapGesture {
                    viewModel.timeDaySelected = .morning
                    viewModel.showSheet = true
                 }
            
            MoodRow(dayImage: "clear_day", dayLabel: TimeOfDay.afternoon.rawValue, feeling: $viewModel.moodItem.afternoon)
                .padding()
                .sheet(isPresented: $viewModel.showSheet, content: {
                    moodSelectSection
                })
                .onTapGesture {
                    viewModel.timeDaySelected = .afternoon
                    viewModel.showSheet = true
                 }
            
            MoodRow(dayImage: "clear_night", dayLabel: TimeOfDay.evening.rawValue, feeling: $viewModel.moodItem.evening)
                .padding([.leading, .bottom, .trailing])
                .sheet(isPresented: $viewModel.showSheet, content: {
                    moodSelectSection
                })
                .onTapGesture {
                    viewModel.timeDaySelected = .evening
                    viewModel.showSheet = true
                 }
        }
        .modifier(CustomCard())
    }
}
private extension MoodView {
    var moodSelectSection: some View {
         VStack {
             HStack{
                 Spacer()
                 Text(LocalizedStringKey(stringLiteral: viewModel.timeofDayMoodLabel))
                     .font(.IBMSemiBold(size: 16))
                 Spacer()
                 CloseImage()
                     .onTapGesture {
                         viewModel.showSheet = false
                     }
             }.padding([.top,.trailing,.leading])
             
             
             HStack {
                 VStack {
                     Text(MoodEmoji.great.rawValue)
                         .font(.system(size: 50))
                     Text("great")
                         .font(.IBMRegular(size: 16))
                 }.onTapGesture {
                     viewModel.showSheet = false
                     viewModel.saveMood(feeling: MoodEmoji.great.rawValue)
                 }
                 
                 VStack {
                     Text(MoodEmoji.good.rawValue)
                         .font(.system(size: 50))
                     Text("good")
                         .font(.IBMRegular(size: 16))
                 }.onTapGesture {
                     viewModel.showSheet = false
                     viewModel.saveMood(feeling: MoodEmoji.good.rawValue)
                 }
                 
                 VStack {
                     Text(MoodEmoji.okay.rawValue)
                         .font(.system(size: 50))
                     Text("okay")
                         .font(.IBMRegular(size: 16))
                 }.onTapGesture {
                     viewModel.showSheet = false
                     viewModel.saveMood(feeling: MoodEmoji.okay.rawValue)
                 }
                 
                 VStack {
                     Text(MoodEmoji.sad.rawValue)
                         .font(.system(size: 50))
                     Text("sad")
                         .font(.IBMRegular(size: 16))
                 }.onTapGesture {
                     viewModel.showSheet = false
                     viewModel.saveMood(feeling: MoodEmoji.sad.rawValue)
                 }
                 
                 VStack {
                     Text(MoodEmoji.awful.rawValue)
                         .font(.system(size: 50))
                     Text("awful")
                         .font(.IBMRegular(size: 16))
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
                    .font(.IBMRegular(size: 16))
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
    MoodView(viewModel: MoodViewModel())
}
