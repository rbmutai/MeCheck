//
//  MoodStatsViewModel.swift
//  MeCheck
//
//  Created by Robert Mutai on 10/04/2024.
//

import Foundation

class MoodStatsViewModel: ObservableObject {
    @Published var moodChartTitle: String = String( localized: "Mood Chart")
    @Published var moodCountTitle: String = String( localized: "Mood Count")
    @Published var moodData: [MoodItem] = []
    @Published var moodsDictionary: [Date: [MoodItem]] = [:]
    @Published var moodCountDictionary: [String: Int] = [:]
    @Published var bestTimeOfDayDictionary: [String: Double] = [:]
    @Published var selectedTimeOfDay: String = ""
    @Published var topMoodLabel: String = ""
    @Published var topMood: String = ""
    @Published var bestTimeOfDayLabel: String = ""
    @Published var bestTimeOfDay: String = ""
    @Published var numDays: CGFloat = 0
    @Published var selectedPeriod: Frequency
    @Published var date: Date
    let persistence = PersistenceController.shared
    let moodYData = ["😀","🙂","😐","🙁","😣"]
    let timeOfDay: [String] = [String(localized: "Morning"), String(localized: "Afternoon"), String(localized: "Evening")]
    var timeOfDayAll: [String] = []
    let emptyData = ["😀":1, "🙂":3, "😐":6, "🙁":8, "😣":10]
    let emptyTimeOfDayData = ["Morning": 30, "Afternoon": 40, "Evening": 30]
    let moodWeight = ["😀":5.0,"🙂":4.0,"😐":3.0,"🙁":2.0,"😣":1.0]
   
   
    init(selectedPeriod: Frequency = .monthly, date: Date) {
        self.selectedPeriod = selectedPeriod
        self.date = date
        timeOfDayAll = [String(localized: "All Day")] + timeOfDay
        selectedTimeOfDay = timeOfDayAll[0]
        moodData = persistence.getMoodData(date: date, frequency: selectedPeriod)
        let range = Calendar.current.range(of: .day, in: .month, for: date)!
        numDays = CGFloat(range.count)
        getMoodCountData()
        getBestTimeOfDayData()
    }
    
    func updateTimeOfDay(item: String){
        selectedTimeOfDay = item
    }
    
    func getMoodChartData(timeOfDay: TimeOfDay = .morning) {
        //chart data for the month/year == separate by time of day ie morning, afternoon, evening
        
        if selectedPeriod == .monthly {
            //month
            moodsDictionary = Dictionary(grouping: moodData) { item -> Date in
               let day = Calendar.current.dateComponents([.day], from: item.date)
               return Calendar.current.date(from: day)!
           }
            
        } else {
            //year
            moodsDictionary =  Dictionary(grouping: moodData) { item -> Date in
                let month = Calendar.current.dateComponents([.month,.year], from: item.date)
                return Calendar.current.date(from: month)!
            }
        }
    }
    
    
    func getMoodCountData() {
        moodCountDictionary = [:]
        for item in moodYData {
            var moodCount = 0
            for mood in moodData {
                if mood.morning == item {
                    moodCount = moodCount+1
                }
                if mood.afternoon == item {
                    moodCount = moodCount+1
                }
                if mood.evening == item {
                    moodCount = moodCount+1
                }
            }
            moodCountDictionary[item] = moodCount
        }
        let moodsArray = moodCountDictionary.sorted(by: {$0.value > $1.value})
        if moodsArray.count > 0 && moodsArray[0].value > 0 {
            topMoodLabel = String(localized: "Top Mood")
            topMood = "\(moodsArray[0].key)"
        } else {
            moodCountDictionary = [:]
        }
        //print(moodsArray)
    }
    func getBestTimeOfDayData() {
        bestTimeOfDayDictionary = [:]
        var morningCount:Double = 0
        var afternoonCount:Double = 0
        var eveningCount:Double = 0
        for item in moodYData {
            for mood in moodData {
                if mood.morning == item {
                    morningCount = morningCount+moodWeight[item]!
                }
                if mood.afternoon == item {
                    afternoonCount = afternoonCount+moodWeight[item]!
                }
                if mood.evening == item {
                    eveningCount = eveningCount+moodWeight[item]!
                }
            }
        }
        morningCount = morningCount/15.0
        afternoonCount = afternoonCount/15.0
        eveningCount = eveningCount/15.0
        
        let total:Double = morningCount + afternoonCount + eveningCount
        
        morningCount = (morningCount/total) * 100
        afternoonCount = (afternoonCount/total) * 100
        eveningCount = (eveningCount/total) * 100
        
        bestTimeOfDayDictionary[timeOfDay[0]] = morningCount
        bestTimeOfDayDictionary[timeOfDay[1]] = afternoonCount
        bestTimeOfDayDictionary[timeOfDay[2]] = eveningCount
        
        let moodsArray = bestTimeOfDayDictionary.sorted(by: {$0.value > $1.value})
        if moodsArray.count > 0 && moodsArray[0].value > 0 {
            bestTimeOfDayLabel = String(localized: "Best Time of Day")
            bestTimeOfDay = "\(moodsArray[0].key)"
        } else {
            bestTimeOfDayDictionary = [:]
        }
        //print(moodsArray)
    }
    
    func moodsByPeriod(moods: [MoodItem], period: Frequency) -> [Date: [MoodItem]] {
        guard !moods.isEmpty else { return [:] }
        
//        let dictionaryByDay = Dictionary(grouping: gratitudes) { item -> Int in
//            let day = Calendar.current.dateComponents([.day], from: item.date).day!
//            return day
//        }
//        let range = Calendar.current.range(of: .day, in: .month, for: date)!
//        let numDays = range.count
//        let days = Array(1...numDays)
//        return days.compactMap({ dictionaryByDay[$0] })

        let dictionary = period == .monthly ? Dictionary(grouping: moods) { item -> Date in
            let day = Calendar.current.dateComponents([.day], from: item.date)
            return Calendar.current.date(from: day)!
        } : Dictionary(grouping: moods) { item -> Date in
            let month = Calendar.current.dateComponents([.month,.year], from: item.date)
            return Calendar.current.date(from: month)!
        }
        
//        let dictionary = Dictionary(grouping: moods) { item -> Int in
//            let day = Calendar.current.dateComponents([.day], from: item.date).day!
//            return day
//        }
            
       
        return dictionary
    }
    
}
