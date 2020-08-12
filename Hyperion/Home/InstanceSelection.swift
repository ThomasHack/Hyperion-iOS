//
//  InstanceSelection.swift
//  Hyperion
//
//  Created by Hack, Thomas on 27.06.20.
//  Copyright © 2020 Hack, Thomas. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

struct InstanceSelection: View {
    let store: Store<Home.HomeFeatureState, Home.Action>

    var body: some View {
        WithViewStore(self.store) { viewStore in
            let runningInstances = viewStore.instances.filter { $0.running }
            if runningInstances.count > 1 {
                VStack(alignment: .leading, spacing: 8) {
                    SectionHeader(text: "Selected Instance")

                    Picker("", selection: viewStore.binding( get: { $0.selectedInstance }, send: Home.Action.selectInstance)) {
                        ForEach(runningInstances, id: \HyperionApi.Instance.self) { instance in
                            Text("\(instance.friendlyName)").tag(instance.instance)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())

                    Spacer()
                        .frame(height: 16.0)

                }
            }
        }
    }
}

struct InstanceSelection_Previews: PreviewProvider {
    static var previews: some View {
        InstanceSelection(store: Main.store.home)
        .previewLayout(.fixed(width: 375, height: 80))
    }
}
