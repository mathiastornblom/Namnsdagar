//
//  AppDelegate.swift
//  Namnsdagar
//
//  Created by Mathias Törnblom on 2024-05-07.
//

import UserNotifications
import UIKit

/// The app delegate responsible for handling app lifecycle events and notifications.
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    /// Handles the app's launch and requests notification authorization.
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Notification permission granted.")
            } else {
                print("Notification permission denied.")
            }
        }
        return true
    }
    
    /// Handles presentation of notifications when the app is in the foreground.
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .badge, .sound])
    }
    
    /// Handles user interaction with notifications.
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // Handle the notification response here (e.g., navigate to a specific view)
        completionHandler()
    }
}
