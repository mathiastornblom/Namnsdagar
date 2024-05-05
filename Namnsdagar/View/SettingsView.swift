//
//  SettingsView.swift
//  Namnsdagar
//
//  Created by Mathias Törnblom on 2024-05-05.
//

import SwiftUI

/// View for managing user settings such as favorite names and notification times.
struct SettingsView: View {
    @ObservedObject var viewModel: SettingsViewModel

    @State private var newFavoriteName: String = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text(NSLocalizedString("FAVORITE_NAMES", comment: "Section header for favorite names"))) {
                    List {
                        ForEach(viewModel.favoriteNames, id: \.self) { name in
                            Text(name)
                        }
                        .onDelete(perform: viewModel.removeFavoriteName)
                        HStack {
                            TextField(NSLocalizedString("ADD_NEW_NAME", comment: "Placeholder text for adding a new favorite name"), text: $newFavoriteName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            Button(action: {
                                viewModel.addFavoriteName(newFavoriteName)
                                newFavoriteName = "" // Clear the text field after adding
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(.green)
                            }
                            .disabled(newFavoriteName.isEmpty) // Disable button if the text field is empty
                        }
                    }
                }

                Section(header: Text(NSLocalizedString("NOTIFICATION_TIME", comment: "Section header for notification time"))) {
                    DatePicker(
                        NSLocalizedString("SELECT_TIME", comment: "Label for selecting notification time"),
                        selection: $viewModel.notificationTime,
                        displayedComponents: .hourAndMinute
                    )
                    .datePickerStyle(WheelDatePickerStyle())
                }
            }
            .navigationBarTitle(NSLocalizedString("SETTINGS", comment: "Navigation bar title for settings view"), displayMode: .inline)
            .navigationBarItems(trailing: EditButton())
        }
    }
}

// SwiftUI preview environment for SettingsView.
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(viewModel: SettingsViewModel())
    }
}
