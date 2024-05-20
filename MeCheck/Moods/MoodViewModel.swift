//
//  MoodViewModel.swift
//  MeCheck
//
//  Created by Robert Mutai on 27/02/2024.
//

import Foundation

enum TimeOfDay: String, CaseIterable {
    case morning = "Morning"
    case afternoon = "Afternoon"
    case evening = "Evening"
}

enum MoodEmoji: String, CaseIterable {
    case great = "😀"
    case good = "🙂"
    case okay = "😐"
    case sad = "🙁"
    case awful = "😣"
}

class MoodViewModel: ObservableObject {
    let persistence = PersistenceController.shared
    var quoteItem: QuoteItem? = nil
    @Published var moodItem: MoodItem = MoodItem(id: 0, morning: "", afternoon: "", evening: "", date: Date())
    @Published var detail: String = ""
    @Published var author: String = ""
    @Published var background: String = ""
    @Published var showSheet: Bool = false
    @Published var showChart: Bool = false
    @Published var moodLabel: String = ""
    @Published var moodSelected: String = ""
    @Published var timeDaySelected: TimeOfDay = .morning
    @Published var moodChartData: [MoodChartItem] = []
    @Published var selectedPeriod: Frequency = .daily
    
    @Published var date = Date()
    var timeofDayMoodLabel: String  {
        "\(timeDaySelected.rawValue) Mood"
    }
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, YYYY"
        return formatter
    }()
    var isFreeView: Bool  {
         if let days  = Calendar.current.dateComponents([.day], from: date, to: .now).day {
             return days <= 4 ? true : false
         }
         return true
    }
    let moodData = ["😀","🙂","😐","🙁","😣"]
    var appNavigation: AppNavigation
    init(appNavigation: AppNavigation) {
        self.appNavigation = appNavigation
        quoteItem = getQuote()
        detail = "\"\(quoteItem?.daily.detail ?? "")\""
        author = "~ \(quoteItem?.daily.author ?? "")"
        background = "\(quoteItem?.backgroundId ?? 1)"
        moodLabel = String(localized: "How did you feel \(Calendar.current.isDateInToday(date) ? String(localized: "today") : Calendar.current.isDateInYesterday(date) ?  String(localized: "yesterday") :  dateFormatter.string(from: date))?")
        
        loadMood()
        
        if (moodItem.morning != "" && moodItem.afternoon != "" && moodItem.evening != "") {
            createChartData()
        }
       
    }
    
    func loadMood() {
        if let newMood = persistence.getMoodForDay(date: date) {
            moodItem = newMood
            createChartData()
        } else {
            moodItem = MoodItem(id: 0, morning: "", afternoon: "", evening: "", date: Date())
            moodChartData.removeAll()
            showChart = false
        }
        moodLabel = String(localized: "How did you feel \(Calendar.current.isDateInToday(date) ? String(localized: "today") : Calendar.current.isDateInYesterday(date) ?  String(localized: "yesterday") :  dateFormatter.string(from: date))?")
        
    }
    
    func saveMood (feeling: String) {
        if moodItem.id == 0 {
            var mood = MoodItem(id: Int.random(in: 1..<1000000), morning: "", afternoon: "", evening: "", date: date)
            if timeDaySelected == .morning {
                mood.morning = feeling
            } else if timeDaySelected == .afternoon {
                mood.afternoon = feeling
            } else {
                mood.evening = feeling
            }
            moodItem = mood
            persistence.saveMood(mood: mood)
           
        } else {
            if timeDaySelected == .morning {
                moodItem.morning = feeling
            } else if timeDaySelected == .afternoon {
                moodItem.afternoon = feeling
            } else {
                moodItem.evening = feeling
            }
            
            persistence.updateMood(mood: moodItem)
        }
        
        if (moodItem.morning != "" && moodItem.afternoon != "" && moodItem.evening != "") {
            createChartData()
        }
        
    }
    
    func createChartData() {
        var moodCount = 0
        moodChartData.removeAll()
        for daytime in TimeOfDay.allCases {
            if daytime == .morning {
                moodChartData.append(MoodChartItem(timeOfDay: String(localized: "Morning"), mood: moodItem.morning))
                if moodItem.morning != "" {
                    moodCount = moodCount + 1
                }
            } else if daytime == .afternoon {
                moodChartData.append(MoodChartItem(timeOfDay: String(localized: "Afternoon"), mood: moodItem.afternoon))
                if moodItem.afternoon != "" {
                    moodCount = moodCount + 1
                }
            } else {
                moodChartData.append(MoodChartItem(timeOfDay: String(localized: "Evening"), mood: moodItem.evening))
                if moodItem.evening != "" {
                    moodCount = moodCount + 1
                }
            }
        }
        
        if moodCount > 2 {
            showChart = true
            NotificationManager.setDefaultReminder()
        } else {
            showChart = false
        }
    }
    
    
    
    func getQuote() -> QuoteItem {
        if let quote = persistence.getQuote() {
            if  Calendar.current.isDateInToday(quote.date) {
                return quote
            } else {
                persistence.deleteQuote()
                var backgroundId = quote.backgroundId
                backgroundId += 1
                if backgroundId > 12 {
                    backgroundId = 1
                }
                
                let newQuote = loadQuote(id: quote.daily.id)
                let quoteItem = QuoteItem(daily: newQuote, backgroundId: backgroundId, date: .now)
                persistence.saveQuote(quoteItem: quoteItem)
                
                return quoteItem
            }
        }
            
        let newQuote = loadQuote()
        let quoteItem = QuoteItem(daily: newQuote, backgroundId: 1, date: .now)
        persistence.saveQuote(quoteItem: quoteItem)
        return quoteItem
    }
    
    func loadQuote(id:Int = 0) -> DailyQuote {
        do {
            let bundleURL = Bundle.main.url(forResource: "Quotes", withExtension: "json")
            let quotesData =  try Data(contentsOf: bundleURL!)
            let decoder = JSONDecoder()
            let quoteItem = try decoder.decode([DailyQuote].self, from: quotesData)
            var quoteId = id
            if quoteId >= quoteItem.count {
                quoteId = 0
            }
            return quoteItem[quoteId]
        } catch let error as NSError {

            return DailyQuote(id: 0, detail: "Don't worry, be happy!", author: "Unknown")
        }
    }
    
}
