//
//  InstanceGridView.swift
//  ControlWidgetExtension
//
//  Created by Hack, Thomas on 17.02.21.
//  Copyright © 2021 Hack, Thomas. All rights reserved.
//

import SwiftUI
import WidgetKit
import HyperionApi

struct InstanceGridView: View {

    let instances: [HyperionApi.Instance?]

    var body: some View {
        Text("Hello, World!")
    }
}

struct InstanceGridView_Previews: PreviewProvider {
    static var previews: some View {
        InstanceGridView(instances: [])
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
