//
//  AddGratitudeViewModel.swift
//  MeCheck
//
//  Created by Robert Mutai on 04/04/2024.
//

import Foundation

class AddGratitudeViewModel: ObservableObject {
    let responsible: [String] = [String(localized: "Family"), String(localized: "Friends"), String(localized: "Neighbour"), String(localized: "Workmate"), String(localized: "Me"), String(localized: "Stranger"), String(localized: "Nobody"), String(localized: "Religion"), String(localized: "Other")]
    let feel : [String] = ["😐","🫠","😊","😁","😍","🤗","🤣","🫢","🤨","😎","😉","😇","😮"]
    @Published var pageTitle: String = String(localized: "New Gratitude Journal")
    @Published var addTitle: String = String(localized: "Create")
    @Published var detail: String = ""
   
    @Published var selectedIconIndex: Int = -1
    @Published var selectedResponsibleIndex: Int = -1
    
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var date: Date
    
    let persistence = PersistenceController.shared
    var gratitudeItem : GratitudeItem?
    
    init(gratitudeItem: GratitudeItem? = nil, date: Date) {
        self.gratitudeItem = gratitudeItem
        self.date = date
        if let item = gratitudeItem {
            detail = item.detail
            pageTitle = String(localized: "Edit Gratitute Journal")
            addTitle = String(localized: "Save")
            selectedIconIndex = getSelectedIconIndex(howFeel: item.icon)
            selectedResponsibleIndex = getSelectedResponsibleIndex(whoResponsible: item.responsible)
        }
        
    }
    
    func getSelectedIconIndex(howFeel: String)->Int {
        for i in 0..<feel.count {
            if howFeel == feel[i] {
                return i
            }
        }
        return -1
    }
    func getSelectedResponsibleIndex(whoResponsible: String)->Int {
        for i in 0..<responsible.count {
            if whoResponsible == responsible[i] {
                return i
            }
        }
        return -1
    }
    
    func saveGratitude() {
        if detail == "" {
            alertMessage = String( localized: "what good thing happened?")
            showAlert = true
        } else if selectedIconIndex == -1 {
            alertMessage = String( localized: "how did you feel?")
            showAlert = true
        } else if selectedResponsibleIndex == -1 {
            alertMessage = String( localized: "who was reponsible?")
            showAlert = true
        } else {
            if gratitudeItem == nil {
                let gratitude = GratitudeItem(id: Int.random(in: 1..<1000000), detail: detail, responsible: responsible[selectedResponsibleIndex], icon: feel[selectedIconIndex], date: date)
                persistence.saveGratitude(gratitude: gratitude)
            } else {
                
                gratitudeItem?.detail = detail
                
                if selectedIconIndex != -1 {
                    gratitudeItem?.icon =  feel[selectedIconIndex]
                }
                
                if selectedResponsibleIndex != -1 {
                    gratitudeItem?.responsible =  responsible[selectedResponsibleIndex]
                }
                
                if let item = gratitudeItem {
                    persistence.updateGratitude(gratitudeItem: item)
                }
            }
        }
    }
}
