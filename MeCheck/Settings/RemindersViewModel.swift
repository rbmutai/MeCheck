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
    @Published var notificationsAllowed: Bool = false
    @Published var reminderItem: ReminderItem? = nil
    @Published var showAlert: Bool = false
    @Published var showSubscription: Bool = false
    let alertMessage = String(localized: "Free limit reached, please upgrade to premium to add more")
    let alertTitle = String(localized: "Upgrade")
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter
    }()
    let persistence = PersistenceController.shared
    
    init() {
        checkReminderStatus()
    }
    
    func checkReminderStatus() {
        NotificationManager.checkNotificationAuthorizationStatus { status in
            DispatchQueue.main.async {
                self.notificationsAllowed = status
                if status {
                  self.reminders = self.persistence.getReminders()
                }
            }
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
        NotificationManager.cancelNotification(id: id)
    }
    
    
    
}
