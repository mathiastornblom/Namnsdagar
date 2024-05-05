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
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Display Year and Week Number
                HStack {
                    Text("\(currentDate.formatted(.dateTime.year()))")
                    Spacer()
                    Text("W. \(currentDate.formatted(.dateTime.week()))")
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
                
                // Display Names that have Name Day
                let nameDays = viewModel.names(for: currentDate)
                if !nameDays.isEmpty {
                    Text(nameDays.joined(separator: ", "))
                        .padding()
                        .font(.title2)
                }
                Spacer()
            }
            .gesture(DragGesture().onEnded(handleSwipe))
            .navigationTitle("Namnsdagar")
            .toolbar {
                leadingToolbarItem
                trailingToolbarItem
            }
            .sheet(isPresented: $showSettings) {
                SettingsView(viewModel: SettingsViewModel())
            }
            .sheet(isPresented: $showSearch) {
                SearchView(viewModel: viewModel)
            }
        }
    }
    
    private var leadingToolbarItem: some ToolbarContent {
        ToolbarItemGroup(placement: .navigationBarLeading) {
            Button(action: viewModel.loadNameDaysForCurrentYear) {
                Image(systemName: "arrow.clockwise")
            }
        }
    }
    
    private var trailingToolbarItem: some ToolbarContent {
        ToolbarItemGroup(placement: .navigationBarTrailing) {
            Button(action: { showSearch = true }) {
                Image(systemName: "magnifyingglass")
            }
            Button(action: { showSettings = true }) {
                Image(systemName: "gear")
            }
        }
    }
    
    private func handleSwipe(_ gesture: DragGesture.Value) {
        let horizontalSwipe = gesture.translation.width
        let verticalSwipe = gesture.translation.height
        
        if abs(horizontalSwipe) > abs(verticalSwipe) {
            let adjustment = horizontalSwipe > 0 ? -1 : 1
            let newDate = Calendar.current.date(byAdding: .day, value: adjustment, to: viewModel.currentDate) ?? viewModel.currentDate
            viewModel.loadNameDays(for: newDate)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: NameDaysViewModel())
    }
}
