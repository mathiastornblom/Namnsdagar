//
//  NamnsdagarApp.swift
//  Namnsdagar
//
//  Created by Mathias Törnblom on 2024-05-05.
//

import SwiftUI

/// A shared environment for the app.
class AppEnvironment {
    static let shared = AppEnvironment()
    let nameDaysViewModel = NameDaysViewModel()
}

/// The main entry point of the Namnsdagar app.
@main
struct NamnsdagarApp: App {
    // Create an instance of the ViewModel
    let viewModel = NameDaysViewModel()
    
    /// Initializes the app and requests notification authorization.
    init() {
        NotificationManager.shared.requestAuthorization()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: AppEnvironment.shared.nameDaysViewModel)
        }
    }
}
