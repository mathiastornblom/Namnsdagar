//
//  SettingsViewModel.swift
//  Namnsdagar
//
//  Created by Mathias Törnblom on 2024-05-05.
//

import Foundation
import Combine

/// ViewModel for managing user settings in the app.
class SettingsViewModel: ObservableObject {
    @Published var favoriteNames: [String]  // Stores the list of user's favorite names.
    @Published var notificationTime: Date  // Stores the preferred time of day for notifications.

    private var userSettings: UserSettings  // Reference to the user settings model for persistence.
    private var cancellables: Set<AnyCancellable> = []  // Stores all subscriptions to allow for cancellation.

    /// Initializes the ViewModel with user settings.
    init(userSettings: UserSettings = UserSettings()) {
        self.userSettings = userSettings
        // Initialize the published properties with values from user settings.
        _favoriteNames = .init(initialValue: userSettings.favoriteNames)
        _notificationTime = .init(initialValue: userSettings.notificationTime)
        
        // Set up bindings to automatically save changes to UserDefaults.
        setupBindings()
    }
    
    /// Sets up Combine bindings to automatically save changes to user settings.
    private func setupBindings() {
        $favoriteNames
            .dropFirst()  // Ignore the initial value provided on subscription.
            .debounce(for: 0.5, scheduler: RunLoop.main)  // Wait for changes to settle before saving.
            .sink(receiveValue: { [weak self] in
                self?.userSettings.favoriteNames = $0
                self?.userSettings.saveSettings()
            })
            .store(in: &cancellables)
        
        $notificationTime
            .dropFirst()  // Ignore the initial value.
            .sink(receiveValue: { [weak self] in
                self?.userSettings.notificationTime = $0
                self?.userSettings.saveSettings()
            })
            .store(in: &cancellables)
    }

    /// Adds a new favorite name to the list.
    /// - Parameter name: The name to be added.
    func addFavoriteName(_ name: String) {
        guard !favoriteNames.contains(name) else { return }
        favoriteNames.append(name)
    }

    // Method to remove a favorite name given an IndexSet
    func removeFavoriteName(at offsets: IndexSet) {
        favoriteNames.remove(atOffsets: offsets)
    }
}

