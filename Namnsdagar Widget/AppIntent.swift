//
//  AppIntent.swift
//  Namnsdagar Widget
//
//  Created by Mathias Törnblom on 2024-05-07.
//

import WidgetKit
import AppIntents

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Configuration"
    static var description = IntentDescription("This widget displays the current date and the name of the day.")

    @Parameter(title: "Favorite Emoji", default: "😃")
    var favoriteEmoji: String
}
