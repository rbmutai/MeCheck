//
//  HomeViewModel.swift
//  MeCheck
//
//  Created by Robert Mutai on 01/03/2024.
//

import Foundation
import Combine
class HomeViewModel: ObservableObject {
    let persistence = PersistenceController.shared
    var quoteItem: QuoteItem?
    @Published var showSheet: Bool = false
    @Published var date = Date()
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, YYYY"
        return formatter
    }()
    
    init() {
        quoteItem = getQuote()
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
