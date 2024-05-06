//
//  CalendarPickerView.swift
//  Namnsdagar
//
//  Created by Mathias Törnblom on 2024-05-05.
//

import SwiftUI

struct CalendarPickerView: View {
    @Binding var selectedDate: Date
    var onSelection: (Date) -> Void // Closure to handle the selection
    
    var body: some View {
        VStack {
            DatePicker("Select a date", selection: $selectedDate, displayedComponents: [.date])
                .datePickerStyle(GraphicalDatePickerStyle())
            Button("Select") {
                onSelection(selectedDate) // Notify the parent view of the selection
            }
            .padding()
        }
        .padding()
        .navigationTitle("Calendar Picker")
    }
}
