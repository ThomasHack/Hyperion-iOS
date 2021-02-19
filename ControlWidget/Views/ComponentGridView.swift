//
//  ComponentGridView.swift
//  ControlWidgetExtension
//
//  Created by Hack, Thomas on 17.02.21.
//  Copyright © 2021 Hack, Thomas. All rights reserved.
//

import SwiftUI
import WidgetKit
import HyperionApi

struct ComponentGridView: View {
    @Environment(\.widgetFamily) var family

    let components: [HyperionApi.Component?]

    var columns: [GridItem] {
        switch family {
        case .systemSmall:
            return [GridItem(.flexible()), GridItem(.flexible())]
        case .systemMedium:
            return [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
        case .systemLarge:
            return [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
        @unknown default:
            return [GridItem(.flexible())]
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            if family == .systemLarge {
                HStack(spacing: 0) {
                    Text("Components")
                        .font(.system(size: 10, weight: .bold, design: .default))
                    Spacer()
                }
                .padding(.horizontal, 8)

                Spacer(minLength: 4)
            }
            LazyVGrid(columns: columns, spacing: 4) {
                ForEach(components, id: \.self) { component in
                    if let component = component {
                        ComponentLinkView(component: component)
                    }
                }
            }
            .padding([.leading, .trailing], 8)
        }
    }
}

struct ComponentGridView_Previews: PreviewProvider {
    static var previews: some View {
        ComponentGridView(components: [
            HyperionApi.Component(name: .videomodehdr, enabled: false),
            HyperionApi.Component(name: .blackborder, enabled: false),
            HyperionApi.Component(name: .smoothing, enabled: true),
            HyperionApi.Component(name: .v4l, enabled: true),
            HyperionApi.Component(name: .led, enabled: true)
        ])
        .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}

