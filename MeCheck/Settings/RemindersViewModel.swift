//
//  RemindersViewModel.swift
//  MeCheck
//
//  Created by Robert Mutai on 01/05/2024.
//

import Foundation
class RemindersViewModel: ObservableObject {
    @Published var reminders : [ReminderItem] = []
    @Published var showSheet: Bool = false
    @Published var isEdit: Bool = false
    @Published var reminderItem: ReminderItem? = nil
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter
    }()
    let persistence = PersistenceController.shared
    var hasSaved: Bool = UserDefaults.standard.bool(forKey: "hasSaved")
    
    init() {
        reminders = persistence.getReminders()
        if reminders.count == 0 && !hasSaved {
            let defaultReminder: ReminderItem = ReminderItem(id: Int.random(in: 1..<1000000), title: String(localized: "Default Reminder"), time: dateFormatter.date(from: "08:00 PM") ?? .now)
            reminders = [defaultReminder]
            persistence.saveReminder(reminder: defaultReminder)
            UserDefaults.standard.set(true, forKey: "hasSaved")
        }
    }
    
    func getReminders() {
        reminders = persistence.getReminders()
        isEdit = false
    }
    
    func editReminder(item: ReminderItem) {
        reminderItem = item
        isEdit = true
        showSheet = true
    }
    
    func deleteReminder(id: Int) {
        persistence.deleteReminder(id: id)
    }
    
    
    
}
