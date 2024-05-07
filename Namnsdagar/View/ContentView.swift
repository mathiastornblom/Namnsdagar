//
//  ContentView.swift
//  Namnsdagar
//
//  Created by Mathias Törnblom on 2024-05-05.
//


import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: NameDaysViewModel
    @State private var showSettings = false
    @State private var showSearch = false
    @State private var currentDate = Date()  // Tracks the current date displayed
    @State private var showCalendarPicker = false
    @State private var selectedDate = Date()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Display Year and Week Number
                HStack {
                    Text("\(currentDate.formatted(.dateTime.year()))").font(.title)
                    Spacer()
                    Text(String(localized: "Week: \(currentDate.formatted(.dateTime.week()))")).font(.title)
                }
                .padding()
                
                // Display Weekday
                Text(currentDate.formatted(.dateTime.weekday(.wide)))
                    .font(.title)
                
                // Display Big Centre Current Date
                Text(currentDate.formatted(Date.FormatStyle().day()))
                    .font(.system(size: 100))
                    .fontWeight(.bold)
                
                // Display Month
                Text(currentDate.formatted(.dateTime.month(.wide)))
                    .font(.title)
                
                // Display Names that have Name Day with favorite toggle
                List(viewModel.names(for: currentDate), id: \.self) { name in
                    HStack {
                        Text(name)
                        Spacer()
                        Button(action: {
                            viewModel.toggleFavorite(name: name)
                        }) {
                            Image(systemName: viewModel.isFavorite(name: name) ? "star.fill" : "star")
                                .foregroundColor(viewModel.isFavorite(name: name) ? .yellow : .gray)
                        }
                    }
                }
                .onAppear {
                    let year = Calendar.current.component(.year, from: viewModel.currentDate)
                    if viewModel.currentYear != year {
                        viewModel.loadNameDaysForYear(year: year)
                    } else {
                        viewModel.loadNameDays(for: viewModel.currentDate)
                    }
                }


                Spacer()
            }
            .navigationBarTitle(String(localized: "Names day")) // Localized navigation bar title
            .navigationBarItems(
                leading: Button(action: viewModel.loadNameDaysForCurrentYear) {
                    Image(systemName: "arrow.clockwise")
                },
                trailing: HStack {
                    Button(action: { showSearch = true }) {
                        Image(systemName: "magnifyingglass")
                    }
                    Button(action: { showSettings = true }) {
                        Image(systemName: "gear")
                    }
                    Button(action: { showCalendarPicker = true }) {
                        Image(systemName: "calendar")
                    }
                }
            )
            .sheet(isPresented: $showSettings) {
                SettingsView(viewModel: viewModel)
            }
            .sheet(isPresented: $showSearch) {
                SearchView(viewModel: viewModel, currentDate: $currentDate, isPresented: $showSearch)
            }
            .sheet(isPresented: $showCalendarPicker) {
                CalendarPickerView(selectedDate: $selectedDate) { selectedDate in
                    currentDate = selectedDate // Update the current date
                    showCalendarPicker = false // Dismiss the calendar picker
                    let selectedYear = Calendar.current.component(.year, from: selectedDate)
                    if selectedYear != viewModel.currentYear {
                        viewModel.loadNameDaysForYear(year: selectedYear)
                    }
                    viewModel.loadNameDays(for: selectedDate) // Load name days for the selected date
                }
            }

        }
        .gesture(
            DragGesture()
                .onEnded { gesture in
                    let horizontalSwipe = gesture.translation.width
                    let verticalSwipe = gesture.translation.height
                    
                    if abs(horizontalSwipe) > abs(verticalSwipe) {
                        let adjustment = horizontalSwipe > 0 ? -1 : 1
                        let newDate = Calendar.current.date(byAdding: .day, value: adjustment, to: currentDate) ?? currentDate
                        currentDate = newDate
                        viewModel.loadNameDays(for: newDate)
                    }
                }
        )
        .gesture(
            TapGesture(count: 2)
                .onEnded {
                    // Navigate to the current day
                    currentDate = Date()
                    viewModel.loadNameDays(for: currentDate)
                }
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: NameDaysViewModel())
    }
}
