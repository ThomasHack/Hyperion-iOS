//
//  InstanceGridView.swift
//  ControlWidgetExtension
//
//  Created by Hack, Thomas on 17.02.21.
//  Copyright © 2021 Hack, Thomas. All rights reserved.
//

import HyperionApi
import SwiftUI
import WidgetKit

struct InstanceGridView: View {
    let instances: [HyperionApi.Instance]

    var columns: [GridItem] {
        [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text("Instances")
                    .font(.system(size: 10, weight: .bold, design: .default))
                Spacer()
            }
            .padding(.horizontal, 8)

            Spacer(minLength: 4)

            LazyVGrid(columns: columns, spacing: 4) {
                ForEach(instances, id: \.self) { instance in
                    InstanceLinkView(instance: instance)
                }
            }
            .padding([.leading, .trailing], 8)
        }
    }
}

struct InstanceGridView_Previews: PreviewProvider {
    static var previews: some View {
        InstanceGridView(instances: [
            HyperionApi.Instance(instance: 0, running: true, friendlyName: "LG OLED Ambilight"),
            HyperionApi.Instance(instance: 1, running: false, friendlyName: "Hue Sync"),
            HyperionApi.Instance(instance: 1, running: false, friendlyName: "Hue Play Lightbars")
        ])
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
