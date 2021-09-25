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

    var horizontalPadding: CGFloat {
        switch family {
        case .systemSmall:
            return 0
        case .systemMedium, .systemLarge, .systemExtraLarge:
            return 8
        @unknown default:
            return 8
        }
    }

    var body: some View {
        VStack {
            switch family {
            case .systemSmall:
                VStack(spacing: 0) {
                    ComponentGridView(components: entry.smallComponents)
                }
            case .systemMedium:
                VStack(spacing: 8) {
                    ComponentGridView(components: entry.mediumComponents)
                }
            case .systemLarge:
                VStack(spacing: 8) {
                    InstanceGridView(instances: entry.instances)
                    ComponentGridView(components: entry.largeComponents)
                }
            case .systemExtraLarge:
                VStack(spacing: 8) {
                    InstanceGridView(instances: entry.instances)
                    ComponentGridView(components: entry.largeComponents)
                }
            @unknown default:
                ComponentGridView(components: entry.smallComponents)
            }
        }
        .padding(.horizontal, horizontalPadding)
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
