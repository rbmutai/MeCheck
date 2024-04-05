//
//  GratitudeViewModel.swift
//  MeCheck
//
//  Created by Robert Mutai on 04/04/2024.
//

import Foundation

class GratitudeViewModel: ObservableObject {
    @Published var introMessage: String = String( localized: "Keep a gratitude journal to keep track of all the good things that happened during the day")
    @Published var gratitudes: [GratitudeItem] = []
    @Published var showSheet: Bool = false
    @Published var date: Date
    @Published var gratitudeItem: GratitudeItem? = nil
    @Published var isEdit: Bool = false
    let persistence = PersistenceController.shared
    
    init(date: Date) {
        self.date = date
        getGratitude()
    }
    func getGratitude() {
        gratitudes = persistence.getGratitude(date: date)
        //gratitudes = [GratitudeItem(id: 1, detail: "I like to relax and code. I also like reading the bible", responsible: "Family", icon: "🙂", date: Date())]
        isEdit = false
    }
    
    func deleteGratitude(id: Int) {
       persistence.deleteGratitude(id: id)
    }
    
    
    func editGratitude(item: GratitudeItem) {
        gratitudeItem = item
        isEdit = true
        showSheet = true
    }
    
}
