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
    let store: Store<Home.HomeFeatureState, Home.Action>

    var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack(alignment: .leading, spacing: 8) {
                SectionHeader(text: "Instances")

                if viewStore.api.instances.count > 0 {
                    HStack(alignment: .top, spacing: 8) {
                        ForEach(viewStore.api.instances, id: \.self) {instance in
                            let imageName = viewStore.icons?[instance.friendlyName]
                            InstanceButton(
                                imageName: imageName,
                                text: instance.friendlyName,
                                isRunning: instance.running,
                                callback: {
                                    viewStore.send(.instanceButtonTapped(instance.instance, instance.running))
                                }
                            )
                        }
                    }
                } else {
                    Text("No instances available")
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                Spacer()
                    .frame(height: 16.0)
            }
        }
    }
}

struct InstanceControl_Previews: PreviewProvider {
    static var previews: some View {
        InstanceControl(store: Main.previewStoreHome)
            .previewLayout(.fixed(width: 375, height: 175))
    }
}
