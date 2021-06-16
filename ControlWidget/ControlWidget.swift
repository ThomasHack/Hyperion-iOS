//
//  ControlWidget.swift
//  ControlWidget
//
//  Created by Hack, Thomas on 15.02.21.
//  Copyright © 2021 Hack, Thomas. All rights reserved.
//

import WidgetKit
import SwiftUI
import Intents
import HyperionApi

struct Provider: IntentTimelineProvider {

    @State var hasFetchedServerInfo: Bool = false
    @State var serverInfo: InfoData?

    func placeholder(in context: Context) -> WidgetEntry {
        let entry = WidgetEntry(date: Date(), info: ApiClient.previewData, configuration: ConfigurationIntent())
        return entry
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (WidgetEntry) -> ()) {
        let date = Date()
        let entry: WidgetEntry

        if context.isPreview && !hasFetchedServerInfo {
            entry = WidgetEntry(date: date, info: ApiClient.previewData, configuration: ConfigurationIntent())
        } else {
            entry = WidgetEntry(date: date, info: serverInfo!, configuration: ConfigurationIntent())
        }
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<WidgetEntry>) -> ()) {
        ApiClient.fetchServerInfo { response in
            switch response {
            case .success(let update):
                self.serverInfo = update.info
                self.hasFetchedServerInfo = true

                let date = Date()
                let entry = WidgetEntry(date: Date(), info: update.info, configuration: configuration)
                let nextUpdateDate = Calendar.current.date(byAdding: .minute, value: 15, to: date)!
                let timeline = Timeline(entries: [entry], policy: .after(nextUpdateDate))
                completion(timeline)
            case .failure(let error):
                print("error: \(error)")
            }
        }
    }
}

struct ControlWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            Color(UIColor.systemBackground)

            VStack(spacing: 0) {
                WidgetHeaderView(title: entry.info.hostname, date: entry.date)
                WidgetContentView(entry: entry)
                Spacer(minLength: 0)
            }
            .padding([.bottom], 8)
        }
    }
}

@main
struct ControlWidget: Widget {
    let kind: String = "de.hyperion-ng.ControlWidget"

    static let previewData = WidgetEntry(date: Date(),
                                            info: ApiClient.previewData,
                                            configuration: ConfigurationIntent())

    static let placeholderData = WidgetEntry(date: Date(),
                                             info: ApiClient.placeholderData,
                                             configuration: ConfigurationIntent())

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            ControlWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Hyperion Control Widget")
        .description("View and control Hyperion-NG Components.")
    }
}

struct ControlWidget_Previews: PreviewProvider {
    static var previews: some View {
        ControlWidgetEntryView(entry: ControlWidget.previewData)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
            //.redacted(reason: .placeholder)
        ControlWidgetEntryView(entry: ControlWidget.previewData)
            .previewContext(WidgetPreviewContext(family: .systemMedium))
            //.redacted(reason: .placeholder)

        ControlWidgetEntryView(entry: ControlWidget.previewData)
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
