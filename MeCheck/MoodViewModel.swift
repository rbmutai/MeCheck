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
    let quoteItem: QuoteItem?
    @Published var moodItem: MoodItem = MoodItem(id: 0, morning: "", afternoon: "", evening: "", date: Date())
    @Published var detail: String = ""
    @Published var author: String = ""
    @Published var background: String = ""
    @Published var date: Date
    @Published var showSheet: Bool = false
    @Published var moodLabel: String = ""
    @Published var moodSelected: String = ""
    @Published var timeDaySelected: TimeOfDay = .morning
    @Published var moodChartData: [MoodChartItem] = []
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, YYYY"
        return formatter
    }()
    let moodData = ["😀","🙂","😐","🙁","😣"]
    init(quoteItem: QuoteItem? = nil, date: Date) {
        self.quoteItem = quoteItem
        self.date = date
        detail = "\"\(quoteItem?.daily.detail ?? "")\""
        author = "~ \(quoteItem?.daily.author ?? "")"
        background = "\(quoteItem?.backgroundId ?? 1)"
        moodLabel = "How did you feel \(Calendar.current.isDateInToday(date) ? "today" : Calendar.current.isDateInYesterday(date) ?  "yesterday" :  dateFormatter.string(from: date))?"
        
        loadMood()
        
        if (moodItem.morning != "" && moodItem.afternoon != "" && moodItem.evening != "") {
            createChartData()
        }
    }
    
    func loadMood() {
        if let newMood = persistence.getMoodForDay(date: date) {
            moodItem = newMood
        }
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
        moodChartData.removeAll()
        for daytime in TimeOfDay.allCases {
            if daytime == .morning {
                moodChartData.append(MoodChartItem(timeOfDay: daytime.rawValue, mood: moodItem.morning))
            } else if daytime == .afternoon {
                moodChartData.append(MoodChartItem(timeOfDay: daytime.rawValue, mood: moodItem.afternoon))
            } else {
                moodChartData.append(MoodChartItem(timeOfDay: daytime.rawValue, mood: moodItem.evening))
            }
        }
    }
    
}
