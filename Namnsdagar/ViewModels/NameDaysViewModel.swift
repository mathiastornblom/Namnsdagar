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

    // MARK: - Published Properties

    @Published var nameDays: [NameDay] = [] // Stores all fetched name days for the current year.
    @Published var currentDate: Date = Date() // Stores the currently selected date.
    @Published var isLoading: Bool = false // Indicates whether data is being fetched.
    @Published var favorites: Set<String> = Set<String>() // Stores favorite names.

    // MARK: - Private Properties

    private var cancellables = Set<AnyCancellable>()
    private var apiService: APIService
    private var notificationService: NotificationService
    var currentYear: Int? // Tracks the currently loaded year for name days.

    // MARK: - Initialization

    init(apiService: APIService = .shared, notificationService: NotificationService = .shared) {
        self.apiService = apiService
        self.notificationService = notificationService

        // Explicit initial load without relying on the currentYear check
        let year = Calendar.current.component(.year, from: currentDate)
        forceLoadNameDaysForYear(year: year)
        loadFavorites()
    }

    // MARK: - Data Loading Methods

    func loadNameDaysForCurrentYear() {
        let year = Calendar.current.component(.year, from: currentDate)
        
        guard !isLoading, currentYear != year else {
            print("Already loading or data loaded for year \(year)")
            return
        }

        loadNameDaysForYear(year: year)
    }

    func loadNameDaysForYear(year: Int) {
        guard !isLoading, currentYear != year else {
            print("Already loading or data loaded for year \(year)")
            return
        }
        if year != currentYear || nameDays.isEmpty {
            forceLoadNameDaysForYear(year: year)
        }
    }

    private func forceLoadNameDaysForYear(year: Int) {
        isLoading = true
        apiService.fetchNameDays(for: year) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let nameDays):
                    self?.nameDays = nameDays
                    self?.currentYear = year // Update the current year on successful fetch
                    print("Data successfully loaded for year \(year)")
                case .failure(let error):
                    print("Error fetching name days for year \(year): \(error)")
                }
            }
        }
//        .store(in: &cancellables) // Handle cancellation on deallocation
    }

    func loadNameDays(for date: Date) {
        let year = Calendar.current.component(.year, from: date)
        if year != currentYear {
            print("Year changed to \(year) from \(String(describing: currentYear)). Reloading data.")
            loadNameDaysForYear(year: year)
        } else {
            print("Year \(year) is already loaded.")
        }
    }

    // MARK: - Name Day Lookup Methods

    func names(for date: Date) -> [String] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)

        guard let nameDay = nameDays.first(where: { $0.datum == dateString }) else {
            return []
        }

        return nameDay.namnsdag
    }

    func findNextNameDay(for name: String) -> Date? {
        print("Searching for name: \(name)")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        for nameDay in nameDays {
            print("Checking \(nameDay.datum) with names \(nameDay.namnsdag)")
            if nameDay.namnsdag.contains(where: { $0.lowercased() == name.lowercased() }) {
                if let date = dateFormatter.date(from: nameDay.datum) {
                    print("Match found for \(name) on \(date)")
                    return date
                }
            }
        }
        print("No match found for \(name)")
        return nil
    }

    // **Potential Optimization:** Consider pre-processing name days for faster search
    func findAllOccurrences(of name: String) -> [(name: String, date: Date)] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        var occurrences: [(name: String, date: Date)] = []

        for nameDay
                in nameDays {
                    for nameInDay in nameDay.namnsdag where nameInDay.lowercased().contains(name.lowercased()) {
                        if let date = dateFormatter.date(from: nameDay.datum) {
                            occurrences.append((nameInDay, date))
                        }
                    }
                }

                return occurrences
            }

            // MARK: - Favorites Management

            // Load favorites from persistent storage
            private func loadFavorites() {
                let savedFavorites = UserDefaults.standard.stringArray(forKey: "Favorites") ?? []
                favorites = Set(savedFavorites)
            }

            // Save favorites to persistent storage
            private func saveFavorites() {
                UserDefaults.standard.set(Array(favorites), forKey: "Favorites")
            }

            // Check if a name is favorite
            func isFavorite(name: String) -> Bool {
                return favorites.contains(name)
            }

            // Toggle the favorite status of a name
            func toggleFavorite(name: String) {
                if favorites.contains(name) {
                    favorites.remove(name)
                } else {
                    favorites.insert(name)
                }
                saveFavorites()
            }

            // MARK: - Notifications

            func scheduleNotification(for name: String) {
                guard let nextNameDayDate = findNextNameDay(for: name) else { return }
                notificationService.scheduleNotification(name: name, date: nextNameDayDate)
            }
        }
