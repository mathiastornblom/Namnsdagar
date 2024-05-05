//
//  DateExtensions.swift
//  Namnsdagar
//
//  Created by Mathias Törnblom on 2024-05-05.
//

import Foundation

/// Extends the Date structure to add utility functions that simplify date handling in the application.
extension Date {
    
    /// Returns the start of the current year.
    var startOfYear: Date {
        let calendar = Calendar.current
        let yearComponent = calendar.component(.year, from: self)
        return calendar.date(from: DateComponents(year: yearComponent, month: 1, day: 1)) ?? self
    }
    
    /// Returns the start of the next year.
    var startOfNextYear: Date {
        let calendar = Calendar.current
        let yearComponent = calendar.component(.year, from: self) + 1
        return calendar.date(from: DateComponents(year: yearComponent, month: 1, day: 1)) ?? self
    }
    
    /// Returns a Boolean value indicating whether the date is today.
    var isToday: Bool {
        return Calendar.current.isDateInToday(self)
    }

    /// Formats the date into a string using the specified format.
    /// - Parameter format: The format string for the date.
    /// - Returns: A formatted string representation of the date.
    func formatted(_ format: String = "yyyy-MM-dd") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }

    /// Adds a specified number of years to the date.
    /// - Parameter years: The number of years to add to the date.
    /// - Returns: The date with the added years, or the original date if not computable.
    func addingYears(_ years: Int) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .year, value: years, to: self) ?? self
    }
    
    /// Compares two dates and returns true if they are the same day.
    /// - Parameter otherDate: The date to compare with.
    /// - Returns: True if the dates are on the same day.
    func isSameDay(as otherDate: Date) -> Bool {
        return Calendar.current.isDate(self, inSameDayAs: otherDate)
    }
}

