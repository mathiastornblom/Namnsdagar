//
//  NamnsdagarApp.swift
//  Namnsdagar
//
//  Created by Mathias Törnblom on 2024-05-05.
//

import SwiftUI

class AppEnvironment {
    static let shared = AppEnvironment()
    let nameDaysViewModel = NameDaysViewModel()
}

@main
struct NamnsdagarApp: App {
    // Create an instance of the ViewModel
    let viewModel = NameDaysViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: AppEnvironment.shared.nameDaysViewModel)
        }
    }
}
