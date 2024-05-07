//
//  SettingsView.swift
//  Namnsdagar
//
//  Created by Mathias Törnblom on 2024-05-05.
//

import SwiftUI

/// A view for managing user settings, specifically for setting notification times and managing favorite names.
struct SettingsView: View {
    @ObservedObject var viewModel: NameDaysViewModel // ViewModel containing settings data and logic.
    @Environment(\.editMode) var editMode // Environment variable to control edit mode of the form.

    var body: some View {
        NavigationView {
            Form {
                notificationTimeSection() // Section for setting the notification time.
                favoriteNamesSection() // Section for managing favorite names.
            }
            .navigationBarTitle(String(localized: "Settings"), displayMode: .inline)
            .onAppear {
                // Automatically set the form to editing mode upon view appearance.
                self.editMode?.wrappedValue = .active
            }
        }
    }

    /// Section view for the notification time picker.
    private func notificationTimeSection() -> some View {
        Section(header: Text(String(localized: "Notification Time"))) {
            DatePicker(
                String(localized: "Select Notification Time"),
                selection: $viewModel.notificationTime,
                displayedComponents: .hourAndMinute
            )
            .datePickerStyle(CompactDatePickerStyle())
            .onChange(of: viewModel.notificationTime) { oldTime, newTime in
                viewModel.saveNotificationTime() // Save whenever the time changes
                viewModel.rescheduleAllNotifications() // Optional: Reschedule all notifications if time changes
            }
        }
    }

    /// Section view for managing favorite names.
    private func favoriteNamesSection() -> some View {
        Section(header: Text(String(localized: "Favorite Names"))) {
            List {
                ForEach(Array(viewModel.favorites), id: \.self) { name in
                    Text(name) // Displays each favorite name.
                }
                .onDelete(perform: deleteFavorites) // Provides functionality to delete favorites.
            }
        }
    }

    /// Handles the deletion of favorite names using offsets from the list.
    private func deleteFavorites(at offsets: IndexSet) {
        for index in offsets {
            let name = Array(viewModel.favorites)[index]
            viewModel.toggleFavorite(name: name) // Toggle the favorite status, effectively removing it.
        }
    }
    
}

// SwiftUI preview environment for SettingsView.
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(viewModel: NameDaysViewModel())
    }
}
