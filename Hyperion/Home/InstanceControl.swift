//
//  InstanceControl.swift
//  Hyperion
//
//  Created by Hack, Thomas on 27.06.20.
//  Copyright © 2020 Hack, Thomas. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

extension HomeView {

    struct InstanceControl: View {
        var store: Store<AppState, AppAction>

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
}

struct InstanceControl_Previews: PreviewProvider {
    static var previews: some View {
        HomeView.InstanceControl(
            store: Store(
                initialState: AppState(
                    instances: [
                        Instance(instance: 0, running: true, friendlyName: "LG OLED TV"),
                        Instance(instance: 1, running: false, friendlyName: "Hue Sync")
                    ]
                ),
                reducer: appReducer,
                environment: AppEnvironment(
                    mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
                    apiClient: .live
                )
            )
        )
        .previewLayout(.fixed(width: 375, height: 150))
    }
}
