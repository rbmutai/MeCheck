//
//  MoodViewModel.swift
//  MeCheck
//
//  Created by Robert Mutai on 27/02/2024.
//

import Foundation

class MoodViewModel: ObservableObject {
    let persistence = PersistenceController.shared
    let quoteItem: QuoteItem?
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, YYYY"
        return formatter
    }()
    @Published var detail: String = ""
    @Published var author: String = ""
    @Published var background: String = ""
    @Published var date: Date
   
    
    init(quoteItem: QuoteItem? = nil, date: Date) {
        self.quoteItem = quoteItem
        self.date = date
        detail = "\"\(quoteItem?.daily.detail ?? "")\""
        author = "~ \(quoteItem?.daily.author ?? "")"
        background = "\(quoteItem?.backgroundId ?? 1)"
    }
}
