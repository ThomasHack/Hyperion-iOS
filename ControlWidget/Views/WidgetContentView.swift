//
//  WidgetContentView.swift
//  ControlWidgetExtension
//
//  Created by Hack, Thomas on 17.02.21.
//  Copyright © 2021 Hack, Thomas. All rights reserved.
//

import SwiftUI
import WidgetKit

struct WidgetContentView: View {
    @Environment(\.widgetFamily) var family
    
    var entry: Provider.Entry

    var body: some View {
        switch family {
        case .systemSmall:
            ComponentGridView(components: entry.smallComponents)
        case .systemMedium:
            VStack {
                ComponentGridView(components: entry.mediumComponents)
                LastUpdated(date: entry.date)
            }
        case .systemLarge:
            VStack(spacing: 8) {
                ComponentGridView(components: entry.largeComponents)
                InstanceGridView(instances: [])
                LastUpdated(date: entry.date)
            }
        @unknown default:
            ComponentGridView(components: entry.smallComponents)
        }

    }
}

struct WidgetContentView_Previews: PreviewProvider {
    static var previews: some View {
        WidgetContentView(entry: ControlWidget.previewData)
            .previewContext(WidgetPreviewContext(family: .systemSmall))

        WidgetContentView(entry: ControlWidget.previewData)
            .previewContext(WidgetPreviewContext(family: .systemMedium))

        WidgetContentView(entry: ControlWidget.previewData)
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
