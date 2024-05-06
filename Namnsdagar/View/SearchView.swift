//
//  SearchView.swift
//  Namnsdagar
//
//  Created by Mathias Törnblom on 2024-05-05.
//

import SwiftUI

struct SearchView: View {
  @ObservedObject var viewModel: NameDaysViewModel
  @Binding var currentDate: Date
  @Binding var isPresented: Bool // Add this to control the view presentation

  @FocusState var focused: Bool?
  @State private var searchQuery: String = ""
  @State private var searchResults: [(name: String, date: Date)] = []
    
  var body: some View {
    NavigationView {
      List {
          TextField("Enter a name", text: $searchQuery)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .focused($focused, equals: true)
            .onChange(of: searchQuery) { oldValue, newValue in
              // Check if the search query has actually changed
              if oldValue != newValue {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { // Delay for 0.1 seconds
                  searchResults = viewModel.findAllOccurrences(of: newValue)
                }
              }
              self.focused = true // Ensure focus remains on TextField
            }

        ForEach(searchResults, id: \.name) { result in
          Button(action: {
            currentDate = result.date
            isPresented = false // Dismiss the view
          }) {
            Text("\(result.name) - \(result.date, formatter: dateFormatter)")
          }
        }
      }
      .navigationBarTitle("Search", displayMode: .inline)
    }
  }

  private var dateFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    formatter.timeStyle = .none
    return formatter
  }
}

struct SearchView_Previews: PreviewProvider {
  static var previews: some View {
    let staticDate = Date()
    let showSearch = Binding.constant(true)
    SearchView(viewModel: NameDaysViewModel(), currentDate: .constant(staticDate), isPresented: showSearch)
  }
}
