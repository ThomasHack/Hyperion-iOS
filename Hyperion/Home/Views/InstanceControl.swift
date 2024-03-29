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

    let columns = [
        GridItem(.adaptive(minimum: UIDevice.current.userInterfaceIdiom == .pad ? 200 : 100))
    ]

    var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack(alignment: .leading, spacing: 8) {
                SectionHeader(text: "Instances")

                if !viewStore.api.instances.isEmpty {
                    LazyVGrid(columns: columns, spacing: 8  ) {
                        ForEach(viewStore.api.instances, id: \.self) { instance in
                            let imageName = viewStore.icons[instance.id]
                            let instanceName = viewStore.state.instanceNames[instance.id] ?? instance.friendlyName
                            InstanceButton(
                                imageName: imageName,
                                text: instanceName.isEmpty ? instance.friendlyName : instanceName,
                                isDisabled: !viewStore.api.allEnabled,
                                isRunning: instance.running && viewStore.api.allEnabled,
                                callback: {
                                    viewStore.send(.instanceButtonTapped(instance.id, instance.running))
                                }
                            )
                        }
                    }
                } else {
                    Text("No instances available")
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                Spacer(minLength: 16)
            }
        }
    }
}

struct InstanceControl_Previews: PreviewProvider {
    static var previews: some View {
        InstanceControl(store: Main.previewStoreHome)
            .previewLayout(.sizeThatFits)
    }
}
