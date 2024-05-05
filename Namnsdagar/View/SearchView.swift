//
//  SearchView.swift
//  Namnsdagar
//
//  Created by Mathias Törnblom on 2024-05-05.
//

import SwiftUI

/// View for searching the next name day occurrence for a specific name.
struct SearchView: View {
    @ObservedObject var viewModel: NameDaysViewModel  // ViewModel to access name day data.

    @State private var searchQuery: String = ""  // State to hold the current search query input by the user.
    @State private var nextNameDayDate: Date?  // State to hold the result of the search.

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Search for a Name Day")) {
                    TextField("Enter a name", text: $searchQuery)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button("Search") {
                        // Perform the search when the button is pressed.
                        nextNameDayDate = viewModel.findNextNameDay(for: searchQuery)
                    }
                    .disabled(searchQuery.isEmpty)  // Disable the button if there is no search query.
                }

                // Optionally display the result of the search.
                if let date = nextNameDayDate {
                    Section(header: Text("Next Name Day")) {
                        Text("The next name day for \(searchQuery) is on \(date, formatter: dateFormatter)")
                            .font(.headline)
                    }
                } else if !searchQuery.isEmpty {
                    Section(header: Text("Next Name Day")) {
                        Text("No upcoming name day found for \(searchQuery).")
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationBarTitle("Name Day Search", displayMode: .inline)
        }
    }

    // DateFormatter to format the displayed date results.
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }
}

#Preview {
    SearchView(viewModel: NameDaysViewModel())
}
