//
//  NameDayWidget.swift
//  Namnsdagar
//
//  Created by Mathias Törnblom on 2024-05-05.
//

import WidgetKit
import SwiftUI
import Intents

/// Represents the data needed for a widget entry.
struct NameDayEntry: TimelineEntry {
    let date: Date
    let nameDays: [String]
}

/// Provider that supplies the data to the widget.
struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> NameDayEntry {
        // Return a dummy entry with example data.
        NameDayEntry(date: Date(), nameDays: ["Anna", "Erik"])
    }

    func getSnapshot(in context: Context, completion: @escaping (NameDayEntry) -> ()) {
        // Return a snapshot entry of your data.
        let entry = NameDayEntry(date: Date(), nameDays: ["Anna", "Erik"])
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<NameDayEntry>) -> ()) {
        // Construct the timeline with entries.
        let currentDate = Date()
        let refreshDate = Calendar.current.date(byAdding: .hour, value: 1, to: currentDate)!
        let entry = NameDayEntry(date: currentDate, nameDays: ["Anna", "Erik"])

        // Create a timeline with the new entry and a reload interval.
        let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
        completion(timeline)
    }
}

/// The view displaying the content of the widget.
struct WidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Name Days Today")
                .bold()
            ForEach(entry.nameDays, id: \.self) { name in
                Text(name)
                    .font(.caption)
            }
        }
        .padding()
    }
}

/// Definition of the widget and its configuration.
struct NameDayWidget: Widget {
    let kind: String = "com.example.namedaywidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            WidgetEntryView(entry: entry)
        }
        .configurationDisplayName(NSLocalizedString("NAME_DAY_TITLE", comment: "Widget Title"))
        .description(NSLocalizedString("WIDGET_DESCRIPTION", comment: "Shows upcoming name days"))
    }
}

struct NameDayWidget_Previews: PreviewProvider {
    static var previews: some View {
        WidgetEntryView(entry: NameDayEntry(date: Date(), nameDays: ["Preview"]))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
