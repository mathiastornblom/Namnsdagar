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

  @FocusState private var isSearchFocused: Bool
  @State private var searchQuery: String = ""
  @State private var searchResults: [(name: String, date: Date)] = []
    @State private var hasSearched: Bool = false  // Track if a search has been performed
    
  var body: some View {
    NavigationView {
      List {
          TextField("Enter a name", text: $searchQuery)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .focused($isSearchFocused)
            .onChange(of: searchQuery) { oldValue, newValue in
                if newValue.isEmpty {
                    searchResults = []
                    hasSearched = false  // Reset the search status
                } else {
                    searchResults = viewModel.findAllOccurrences(of: newValue)
                    hasSearched = true  // Update search status to true
                }
            }
            .onAppear{
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { // Delay for 0.1 seconds
                    self.isSearchFocused = true // Ensure focus remains on TextField
              }
            
            }
          // Check if results are empty and a search has been performed
          if searchResults.isEmpty && hasSearched {
              Text("No results found for '\(searchQuery)'. Please try another name.")
                  .foregroundColor(.red)
          } else {
              ForEach(searchResults, id: \.name) { result in
                  Button(action: {
                      currentDate = result.date
                      isPresented = false // Dismiss the view
                  }) {
                      Text("\(result.name) - \(result.date, formatter: dateFormatter)")
                  }
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
