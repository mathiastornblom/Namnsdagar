//
//  Constants.swift
//  Namnsdagar
//
//  Created by Mathias Törnblom on 2024-05-05.
//

import Foundation

/// Defines constants used throughout the application.
struct Constants {
    // The base URL for the name day API.
    static let apiBaseURL = "https://sholiday.faboul.se/dagar/v2.1/"

    // Default API year query part. Used for fetching data when no specific year is given.
    static let defaultYearQuery = "2024"

    // Notification identifiers for user settings.
    struct Notifications {
        static let favoriteNameDayReminderId = "favoriteNameDayReminder"
    }

    // User default keys for storing app-specific settings.
    struct UserDefaults {
        static let favoriteNamesKey = "favoriteNames"
        static let notificationTimeKey = "notificationTime"
    }

    // Date and time formats used across the app.
    struct DateFormat {
        static let apiDate = "yyyy/MM/dd"
        static let displayDate = "EEEE, MMMM d, yyyy"
    }
}
