//
//  Namnsdagar_WidgetEntry.swift
//  Namnsdagar WidgetExtension
//
//  Created by Mathias Törnblom on 2024-05-07.
//  Copyright © 2024 net.tornbloms. All rights reserved.
//

import WidgetKit
import SwiftUI

struct SimpleEntry: TimelineEntry {
    let date: Date
    let nameOfTheDay: String
    let dayNumber: Int
    let month: String
    let names: [String]
}
