//
//  ComponentLinkView.swift
//  Hyperion
//
//  Created by Hack, Thomas on 16.02.21.
//  Copyright © 2021 Hack, Thomas. All rights reserved.
//

import HyperionApi
import SwiftUI
import WidgetKit

struct ComponentLinkView: View {
    @Environment(\.widgetFamily) var family

    let component: HyperionApi.Component

    var urlString: String {
        let string = "hyperion://control/component/\(component.name.rawValue)/\(component.enabled ? "false" : "true")"
        return string
    }

    var imageSize: CGSize {
        switch family {
        case .systemSmall:
            return CGSize(width: 24, height: 24)
        case .systemMedium, .systemLarge:
            return CGSize(width: 42, height: 42)
        case .systemExtraLarge:
            return CGSize(width: 42, height: 42)
        @unknown default:
            return CGSize(width: 42, height: 42)
        }
    }

    var circleSize: CGSize {
        switch family {
        case .systemSmall:
            return CGSize(width: 6, height: 6)
        case .systemMedium, .systemLarge:
            return CGSize(width: 8, height: 8)
        case .systemExtraLarge:
            return CGSize(width: 8, height: 8)
        @unknown default:
            return CGSize(width: 8, height: 8)
        }
    }

    var fontSize: CGFloat {
        switch family {
        case .systemSmall:
            return 7
        case .systemMedium:
            return 8
        case .systemLarge:
            return 8
        case .systemExtraLarge:
            return 8
        @unknown default:
            return 8
        }
    }

    var spacing: CGFloat {
        switch family {
        case .systemSmall:
            return 4
        case .systemMedium, .systemLarge:
            return 8
        case .systemExtraLarge:
            return 8
        @unknown default:
            fatalError()
        }
    }

    var body: some View {
        if let url = URL(string: urlString) {
            Link(destination: url) {
                ZStack {
                    VStack(spacing: 0) {
                        VStack(spacing: 0) {
                            Image(component.image)
                                .resizable()
                                .clipped()
                                .padding(2)
                        }
                        .frame(width: imageSize.width, height: imageSize.height, alignment: .center)
                        .background(Color(UIColor.systemBackground))
                        .cornerRadius(imageSize.width / 2)

                        Spacer(minLength: 8)

                        Text(component.label)
                            .font(.system(size: fontSize, weight: .bold, design: Font.Design.default))
                            .multilineTextAlignment(.center)
                            .lineLimit(2)

                        Spacer(minLength: 0)
                    }
                    .padding(.vertical, spacing)
                    .padding(.horizontal, spacing)

                    if component.enabled {
                        VStack {
                            HStack {
                                Spacer()
                                Circle()
                                    .foregroundColor(.green)
                                    .frame(width: circleSize.width, height: circleSize.height)
                            }
                            Spacer()
                        }
                        .padding(4)
                    }
                }
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .foregroundColor(component.enabled ? Color(UIColor.label) : Color(UIColor.secondaryLabel))
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(10)
        }
    }
}

struct ComponentLinkView_Previews: PreviewProvider {
    static var previews: some View {
        let component = HyperionApi.Component(name: .blackborder, enabled: true)

        ZStack {
            Color(UIColor.secondarySystemBackground)
            VStack(spacing: 0) {
                Spacer(minLength: 16)
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                    ComponentLinkView(component: component)
                }
                .padding([.leading, .trailing], 8)
                Spacer()
            }
        }
        .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
