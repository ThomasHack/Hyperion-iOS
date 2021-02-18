//
//  ComponentGridView.swift
//  ControlWidgetExtension
//
//  Created by Hack, Thomas on 17.02.21.
//  Copyright © 2021 Hack, Thomas. All rights reserved.
//

import SwiftUI
import WidgetKit

struct ComponentGridView: View {
    @Environment(\.widgetFamily) var family

    let components: [Component?]

    var columns: [GridItem] {
        switch family {
        case .systemSmall:
            return [GridItem(.flexible()), GridItem(.flexible())]
        case .systemMedium:
            return [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
        case .systemLarge:
            return [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), ]
        @unknown default:
            return [GridItem(.flexible())]
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            LazyVGrid(columns: columns) {
                ForEach(components, id: \.self) { component in
                    if let component = component {
                        ComponentLinkView(component: component)
                    }
                }
            }
            .fixedSize(horizontal: false, vertical: true)
            .padding([.leading, .trailing], 8)
            Spacer(minLength: 0)
        }
    }
}

struct ComponentGridView_Previews: PreviewProvider {
    static var previews: some View {
        ComponentGridView(components: [
            Component(name: "", label: "HDR Tone Mapping", image: "hdr-tone-mapping", enabled: true),
            Component(name: "", label: "Blackborder Detection", image: "blackborder", enabled: false),
            Component(name: "", label: "Motion Smoothing", image: "smoothing", enabled: false),
            // Component(name: "", label: "External Grabber", image: "v4l-hardware", enabled: true),
            Component(name: "", label: "LED Hardware", image: "led-hardware", enabled: true)
        ])
        .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}

