//
//  AddReminderViewModel.swift
//  MeCheck
//
//  Created by Robert Mutai on 06/05/2024.
//

import Foundation

class AddReminderViewModel: ObservableObject {
    @Published var pageTitle: String = String(localized: "New Reminder")
    @Published var addTitle: String = String(localized: "Create")
    @Published var title: String = ""
    @Published var time: Date = .now
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    let alertTitle: String = String(localized: "Alert")
    let persistence = PersistenceController.shared
    var reminder : ReminderItem?
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter
    }()
    
    init(reminder: ReminderItem? = nil) {
        self.reminder = reminder
        time = dateFormatter.date(from: "08:00 PM") ?? .now
        
        if let item = reminder {
            title = item.title
            time = item.time
            pageTitle = String(localized: "Edit Reminder")
            addTitle = String(localized: "Save")
        }
        
    }
    
    func saveReminder() {
        if title == "" {
            alertMessage = String( localized: "Title?")
            showAlert = true
        } else {
            if reminder == nil {
                let reminderItem = ReminderItem(id: Int.random(in: 1..<1000000), title: title, time: time)
                persistence.saveReminder(reminder: reminderItem)
                NotificationManager.scheduleNotification(reminder: reminderItem)
            } else {
                reminder?.title = title
                reminder?.time = time
                
                if let item = reminder {
                    persistence.updateReminder(reminderItem: item)
                    NotificationManager.cancelNotification(id: item.id)
                    NotificationManager.scheduleNotification(reminder: item)
                }
            }
        }
    }
}
