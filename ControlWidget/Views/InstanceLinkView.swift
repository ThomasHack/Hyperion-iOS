//
//  InstanceLinkView.swift
//  ControlWidgetExtension
//
//  Created by Hack, Thomas on 19.02.21.
//  Copyright © 2021 Hack, Thomas. All rights reserved.
//

import SwiftUI
import WidgetKit
import HyperionApi

struct InstanceLinkView: View {
    var instance: HyperionApi.Instance

    var icons: [String: String]? {
        return ApiClient.userDefaults?.value(forKey: ApiClient.iconsDefaultsKeyName) as? [String: String] ?? [:]
    }

    var image: String? {
        return icons?[instance.friendlyName]
    }

    var url: String {
        let string = "hyperion://control/instance/\(instance.instance)/\(instance.running ? "false" : "true")"
        return string
    }

    var body: some View {
        Link(destination: URL(string: url)!) {
            ZStack() {
                VStack(spacing: 0) {
                    VStack(spacing: 0) {
                        if let image = image {
                            Image(image)
                                .resizable()
                                .clipped()
                                .padding(2)
                        }
                    }
                    .frame(width: 42, height: 42, alignment: .center)
                    .background(Color(UIColor.systemBackground))
                    .cornerRadius(42/2)

                    Spacer(minLength: 8)

                    Text(instance.friendlyName)
                        .font(.system(size: 8, weight: .bold, design: Font.Design.default))
                        .multilineTextAlignment(.center)
                        .lineLimit(2)

                    Spacer(minLength: 0)
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 8)

                if instance.running {
                    VStack() {
                        HStack() {
                            Spacer()
                            Circle()
                                .foregroundColor(.green)
                                .frame(width: 8, height: 8)
                        }
                        Spacer()
                    }
                    .padding(4)
                }
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .foregroundColor(instance.running ? Color(UIColor.label) : Color(UIColor.secondaryLabel))
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(10)
    }
}

struct InstanceLinkView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color(UIColor.secondarySystemBackground)
            VStack(spacing: 0) {
                Spacer(minLength: 16)
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                    InstanceLinkView(instance: HyperionApi.Instance(instance: 0, running: true, friendlyName: "Ambilight"))
                }
                .padding([.leading, .trailing], 8)
                Spacer()
            }
        }
        .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
