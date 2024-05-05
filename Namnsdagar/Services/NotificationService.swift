//
//  NotificationService.swift
//  Namnsdagar
//
//  Created by Mathias Törnblom on 2024-05-05.
//

import UserNotifications

/// Manages local notifications for name day reminders.
class NotificationService {
    // Singleton instance to ensure the service is used uniformly throughout the app.
    static let shared = NotificationService()

    /// Requests permission to send notifications from the user.
    func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        // Request authorization for alert, sound, and badge.
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            DispatchQueue.main.async {
                completion(granted, error)
            }
        }
    }

    /// Schedules a local notification for a specific name day.
    /// - Parameters:
    ///   - name: The name for which to schedule the notification.
    ///   - date: The date and time at which the notification should fire.
    func scheduleNotification(name: String, date: Date) {
        // Create content for the notification.
        let content = UNMutableNotificationContent()
        content.title = NSLocalizedString("NAME_DAY_TITLE", comment: "Notification title for name day reminder")
        content.body = String(format: NSLocalizedString("TODAY_IS", comment: "Body text"), name)
        content.sound = UNNotificationSound.default

        // Create a calendar trigger for the notification.
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)

        // Create a request with a unique identifier.
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        // Add the request to the system.
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            }
        }
    }
}
