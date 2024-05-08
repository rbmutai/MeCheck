//
//  NotificationManager.swift
//  MeCheck
//
//  Created by Robert Mutai on 07/05/2024.
//

import Foundation
import UserNotifications

struct NotificationManager {
    static let persistence = PersistenceController.shared
    
    // Request user authorization for notifications
    static func requestNotificationAuthorization(completion : @escaping (Bool)-> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { success, error in
            if success {
                print("Notification authorization granted.")
            } else if let error = error {
                print(error.localizedDescription)
            }
            completion(success)
        }
    }
    static func checkNotificationAuthorizationStatus(completion : @escaping (Bool)-> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                requestNotificationAuthorization { success in
                    completion(success)
                }
            case .denied:
                completion(false)
            case .authorized, .provisional,.ephemeral:
                completion(true)
            @unknown default:
                completion(false)
            }
        }
    }
    
    static func setDefaultReminder() {
        //will only set once
        if !UserDefaults.standard.bool(forKey: "hasSaved") {
            UserDefaults.standard.set(true, forKey: "hasSaved")
            NotificationManager.requestNotificationAuthorization { success in
                if success {
                    //user has allowed notifications
                    if persistence.getReminders().count == 0 {
                        let formatter = DateFormatter()
                        formatter.dateFormat = "hh:mm a"
                        let defaultReminder: ReminderItem = ReminderItem(id: 0, title: String(localized: "Default Reminder"), time: formatter.date(from: "08:00 PM") ?? .now)
                        self.persistence.saveReminder(reminder: defaultReminder)
                    }
                }
            }
        }
    }
    
    // Schedule daily notification at user-selected time
    static func scheduleNotification(reminder: ReminderItem) {
       
        // Instantiate a variable for UNMutableNotificationContent
        let content = UNMutableNotificationContent()
        // The notification title
        content.title = reminder.id == 0 ? Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? "MeCheck" : reminder.title
        // The notification body
        content.body = String(localized: "Take a moment to update your mood, habits and gratitude journal")
        content.sound = .default
        
        // Set the notification to repeat daily for the specified hour and minute
        let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: reminder.time)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        // We need the identifier so that we can cancel it later if needed
        // The identifier name could be anything, up to you
        let request = UNNotificationRequest(identifier: "\(reminder.id)", content: content, trigger: trigger)
        
        // Schedule the notification
        UNUserNotificationCenter.current().add(request)
        
//        // Schedule the request with the system.
//        let notificationCenter = UNUserNotificationCenter.current()
//        do {
//            try await notificationCenter.add(request)
//        } catch {
//            // Handle errors that may occur during add.
//        }
    }
    
    // Cancel any scheduled notifications
    static func cancelNotification(id: Int) {
        // Cancel the notification with identifier "journalReminder"
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["\(id)"])
    }
}
