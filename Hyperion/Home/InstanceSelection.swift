//
//  InstanceSelection.swift
//  Hyperion
//
//  Created by Hack, Thomas on 27.06.20.
//  Copyright © 2020 Hack, Thomas. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

extension HomeView {

    struct InstanceSelection: View {
        var store: Store<HomeState, HomeAction>

        var body: some View {
            WithViewStore(self.store) { viewStore in
                VStack(alignment: .leading, spacing: 8) {
                    SectionHeader(text: "Selected Instance")
                    Picker("", selection: viewStore.binding( get: { $0.selectedInstance }, send: HomeAction.selectInstance)) {
                        ForEach(viewStore.instances.filter { $0.running }, id: \.self) {instance in
                            Text("\(instance.friendlyName)").tag(instance.instance)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
            }
        }
    }
}

struct InstanceSelection_Previews: PreviewProvider {
    static var previews: some View {
        HomeView.InstanceSelection(
            store: Store(
                initialState: HomeState(
                    instances: [
                        Instance(instance: 0, running: true, friendlyName: "LG OLED TV"),
                        Instance(instance: 1, running: true, friendlyName: "Hue Sync")
                    ]
                ),
                reducer: homeReducer,
                environment: MainEnvironment(
                    mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
                    apiClient: .live
                )
            )
        )
        .previewLayout(.fixed(width: 375, height: 80))
    }
}
