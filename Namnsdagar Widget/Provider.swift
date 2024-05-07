//
//  Provider.swift
//  Namnsdagar WidgetExtension
//
//  Created by Mathias Törnblom on 2024-05-07.
//  Copyright © 2024 net.tornbloms. All rights reserved.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), nameOfTheDay: "Loading...", dayNumber: 0, month: "", names: [])
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        try! await fetchData(for: Date())
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        let currentDate = Date()
        guard let entry = try? await fetchData(for: currentDate) else {
            return Timeline(entries: [SimpleEntry(date: currentDate, nameOfTheDay: "Error", dayNumber: 0, month: "", names: [])], policy: .atEnd)
        }
        return Timeline(entries: [entry], policy: .atEnd)
    }

    private func fetchData(for date: Date) async throws -> SimpleEntry {
        // Fetch data from the API using URLSession or other networking libraries
        
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        
        guard (1...12).contains(month) else {
            throw NSError(domain: "Provider", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid month value"])
        }
        
        let url = URL(string: "https://sholiday.faboul.se/dagar/v2.1/\(year)/\(month)/\(day)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        let response = try decoder.decode(ApiResponse.self, from: data)
        
        // Extract the necessary fields from the API response
        let monthIndex = Calendar.current.component(.month, from: date)
        guard let nameOfTheDay = response.dagar.first?.veckodag,
              let dayNumberString = response.dagar.first?.datum,
              let dayNumber = Int(dayNumberString),
              //let monthName = Calendar.current.monthSymbols[monthIndex - 1],
              let names = response.dagar.first?.namnsdag else {
            throw NSError(domain: "Provider", code: 1, userInfo: [NSLocalizedDescriptionKey: "Unable to fetch required data from the API"])
        }

        return SimpleEntry(date: date, nameOfTheDay: nameOfTheDay, dayNumber: dayNumber, month: Calendar.current.monthSymbols[monthIndex - 1], names: names)
    }

}

