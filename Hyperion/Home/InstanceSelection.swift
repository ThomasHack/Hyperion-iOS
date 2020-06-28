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
    let store: Store<Home.State, Home.Action>

    var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack(alignment: .leading, spacing: 8) {
                SectionHeader(text: "Selected Instance")

                Picker("", selection: viewStore.binding( get: { $0.selectedInstance }, send: Home.Action.selectInstance)) {
                    ForEach(viewStore.instances.filter { $0.running }, id: \.self) {instance in
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

struct InstanceSelection_Previews: PreviewProvider {
    static var previews: some View {
        InstanceSelection(
            store: Main.initialStore.homeStore
        )
        .previewLayout(.fixed(width: 375, height: 80))
    }
}
