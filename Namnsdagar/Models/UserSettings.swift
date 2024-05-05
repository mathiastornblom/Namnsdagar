//
//  UserSettings.swift
//  Namnsdagar
//
//  Created by Mathias Törnblom on 2024-05-05.
//

import Foundation

/// Manages user-specific settings such as notification times and favorite names.
class UserSettings: ObservableObject {
    // MARK: - Properties
    @Published var favoriteNames: [String] = [] // Stores user's favorite names for notifications.
    @Published var notificationTime: Date = Date() // The time of day the user prefers to receive notifications.
    
    // MARK: - Initialization
    init() {
        loadSettings()
    }
    
    // MARK: - Methods

    /// Loads the user's settings from UserDefaults. If not present, sets defaults.
    private func loadSettings() {
        if let savedNames = UserDefaults.standard.object(forKey: "favoriteNames") as? [String] {
            favoriteNames = savedNames
        }
        
        if let savedTime = UserDefaults.standard.object(forKey: "notificationTime") as? Date {
            notificationTime = savedTime
        }
    }

    /// Saves the current favorite names and notification time to UserDefaults.
    func saveSettings() {
        UserDefaults.standard.set(favoriteNames, forKey: "favoriteNames")
        UserDefaults.standard.set(notificationTime, forKey: "notificationTime")
    }
    
    /// Adds a new favorite name to the list and saves the updated list.
    /// - Parameter name: The name to be added to favorites.
    func addFavoriteName(_ name: String) {
        if !favoriteNames.contains(name) {
            favoriteNames.append(name)
            saveSettings()
        }
    }

    /// Removes a favorite name from the list and saves the updated list.
    /// - Parameter name: The name to be removed from favorites.
    func removeFavoriteName(_ name: String) {
        favoriteNames.removeAll { $0 == name }
        saveSettings()
    }
}

