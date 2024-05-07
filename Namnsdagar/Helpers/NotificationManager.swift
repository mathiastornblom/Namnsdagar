//
//  NotificationManager.swift
//  Namnsdagar
//
//  Created by Mathias Törnblom on 2024-05-07.
//

import UserNotifications
import SwiftUI

class NotificationManager {
    static let shared = NotificationManager()

    // Store notification identifiers
    private var notificationIDs: [String: String] = [:]
    
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Notification permission granted.")
            } else {
                print("Notification permission denied.")
            }
        }
    }

    func scheduleNotification(for name: String, on date: Date) {
        let content = UNMutableNotificationContent()
        content.title = "Name Day Reminder!"
        content.body = "Tomorrow is \(name)'s name day!"
        content.sound = UNNotificationSound.default  // Correct usage of the .default property

        // Get the user's current time zone
        let timeZone = TimeZone.current

        // Prepare date components, including the time zone
        var dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        dateComponents.timeZone = timeZone  // Explicitly set the time zone

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification for \(name): \(error.localizedDescription)")
            } else {
                print("Notification successfully scheduled for \(name) at \(trigger.nextTriggerDate() ?? Date())")
            }
        }
    }

    func unscheduleNotification(for name: String) {
        guard let identifier = notificationIDs[name] else { return }
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
        print("Notification for \(name) has been unscheduled.")
        notificationIDs.removeValue(forKey: name)
    }
}
