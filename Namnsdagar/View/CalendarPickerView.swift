//
//  CalendarPickerView.swift
//  Namnsdagar
//
//  Created by Mathias Törnblom on 2024-05-05.
//

import SwiftUI

/// A view for selecting a date from a calendar.
struct CalendarPickerView: View {
    
    // MARK: - Properties
    
    @Binding var selectedDate: Date // Stores the selected date
    var onSelection: (Date) -> Void // Closure to handle the selection
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            // Date picker for selecting a date
            DatePicker(String(localized: "Select a date"), selection: $selectedDate, displayedComponents: [.date])
                .datePickerStyle(GraphicalDatePickerStyle())
            
            // Button to confirm the selection
            Button(String(localized: "Select")) {
                // Notify the parent view of the selected date
                onSelection(selectedDate)
            }
            .padding()
        }
        .padding()
        .navigationTitle(String(localized: "Calendar Picker")) // Navigation title for the view
    }
}
