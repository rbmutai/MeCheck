//
//  HomeViewModel.swift
//  MeCheck
//
//  Created by Robert Mutai on 01/03/2024.
//

import Foundation
import Combine

enum Frequency: String, CaseIterable, Decodable {
    case daily = "Daily"
    case weekly = "Weekly"
    case monthly = "Monthly"
    case yearly = "Yearly"
}

enum HabitColors: String, Decodable {
    case Purple = "Purple"
    case Blue = "Blue"
    case Brown = "Brown"
    case Green = "Green"
    case Maroon = "Maroon"
    case Pink = "Pink"
    case Yellow = "Yellow"
    case Peach = "Peach"
    case Red = "Red"
    case Orange = "Orange"
    case Sage = "Sage"
    case LightGrey = "LightGrey"
}

class HomeViewModel: ObservableObject {
    let persistence = PersistenceController.shared
    var quoteItem: QuoteItem?
    @Published var showSheet: Bool = false
    @Published var selectedPeriod: Frequency = .daily
    @Published var date = Date()
    var dateLabel: String {
        Calendar.current.isDateInToday(date) && selectedPeriod == .daily ? String(localized: "Today") : Calendar.current.isDateInYesterday(date) && selectedPeriod == .daily ? String(localized: "Yesterday") : Calendar.current.isDateInTomorrow(date) && selectedPeriod == .daily ? String(localized: "Tomorrow") : dateFormatter.string(from: date)
    }
    
    @Published var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, YYYY"
        return formatter
    }()
    
    init() {
        quoteItem = getQuote()
        
        if selectedPeriod == .daily {
            dateFormatter.dateFormat =  "MMM dd, YYYY"
        } else if selectedPeriod == .monthly {
            dateFormatter.dateFormat =  "MMMM, YYYY"
        } else if selectedPeriod == .yearly {
            dateFormatter.dateFormat =  "YYYY"
        }
    }
    
    func updateDate(by: Int) {
        if let newDate = Calendar.current.date(byAdding: selectedPeriod == .daily ? .day : selectedPeriod == .monthly ? .month : .year , value: by, to: date) {
            date = newDate
//            if by < 0 {
//                date = newDate
//            } else if by > 0 && newDate <= .now {
//                date = newDate
//            }
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
            print("Error \(error)")
            return DailyQuote(id: 0, detail: "Don't worry, be happy!", author: "Unknown")
        }
    }
    
}
