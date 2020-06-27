//
//  InstanceControl.swift
//  Hyperion
//
//  Created by Hack, Thomas on 27.06.20.
//  Copyright © 2020 Hack, Thomas. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

struct InstanceControl: View {
    let store: Store<Home.State, Home.Action>

    var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack(alignment: .leading, spacing: 8) {
                SectionHeader(text: "Instances")
                HStack {
                    ForEach(viewStore.instances, id: \.self) {instance in
                        IntensityButton(imageName: instance.friendlyName == "LG OLED Ambilight" ? "tv" : "lightbulb", text: instance.friendlyName, running: instance.running, callback: {
                            viewStore.send(.instanceButtonTapped(instance.instance, instance.running))
                        })
                    }
                }
            }
        }
    }
}

struct InstanceControl_Previews: PreviewProvider {
    static var previews: some View {
        InstanceControl(
            store: Main.initialStore.homeStore
        )
        .previewLayout(.fixed(width: 375, height: 150))
    }
}
