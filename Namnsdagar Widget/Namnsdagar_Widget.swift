//
//  Namnsdagar_Widget.swift
//  Namnsdagar Widget
//
//  Created by Mathias Törnblom on 2024-05-07.
//

import WidgetKit
import SwiftUI

struct Namnsdagar_Widget: Widget {
    let kind: String = "Namnsdagar_Widget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            Namnsdagar_WidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
    }
}

struct Namnsdagar_WidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text("\(entry.nameOfTheDay)")
            Text("\(entry.dayNumber)")
                .font(.system(size: 40, weight: .bold, design: .default))

            Text("\(entry.month)")
            HStack {
                Text(entry.names.joined(separator: ", "))
            }
        }
        .containerBackground(.fill.tertiary, for: .widget) // Add container background modifier here
    }
}


struct Namnsdagar_WidgetPreview: PreviewProvider {
    static var previews: some View {
        Namnsdagar_WidgetEntryView(entry: SimpleEntry(date: Date(), nameOfTheDay: "Monday", dayNumber: 2, month: "May", names: ["Anna","Lisa"]  ))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
