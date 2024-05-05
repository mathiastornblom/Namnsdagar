//
//  NameDaysViewModel.swift
//  Namnsdagar
//
//  Created by Mathias Törnblom on 2024-05-05.
//

import Foundation
import Combine

/// ViewModel for managing name day data and user interactions.
class NameDaysViewModel: ObservableObject {
    @Published var nameDays: [NameDay] = []  // Stores all fetched name days for the current year.
    @Published var currentDate: Date = Date()  // Stores the currently selected date.
    @Published var isLoading: Bool = false  // Indicates whether data is being fetched.
    
    private var cancellables: Set<AnyCancellable> = []
    private var apiService: APIService
    private var notificationService: NotificationService
    
    init(apiService: APIService = .shared, notificationService: NotificationService = .shared) {
        self.apiService = apiService
        self.notificationService = notificationService
        loadNameDaysForCurrentYear()
    }
    
    func loadNameDaysForCurrentYear() {
        let year = Calendar.current.component(.year, from: currentDate)
        isLoading = true
        apiService.fetchNameDays(for: year) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let fetchedNameDays):
                    self?.nameDays = fetchedNameDays
                case .failure(let error):
                    print("Error fetching name days: \(error)")
                }
            }
        }
    }
    
    func loadNameDays(for date: Date) {
        currentDate = date
        // Assuming the nameDays array already contains the entire year's data
        // No need to fetch again if data for the year is already loaded
    }

    func names(for date: Date) -> [String] {
        guard let nameDay = nameDays.first(where: { DateFormatter().date(from: $0.datum) == date }) else {
            return []
        }
        return nameDay.namnsdag
    }
    
    func findNextNameDay(for name: String) -> Date? {
        guard let nameDay = nameDays.first(where: { $0.namnsdag.contains(name) }),
              let date = DateFormatter().date(from: nameDay.datum) else { return nil }
        return date
    }
    
    func scheduleNotification(for name: String) {
        guard let nextNameDayDate = findNextNameDay(for: name) else { return }
        notificationService.scheduleNotification(name: name, date: nextNameDayDate)
    }
}
