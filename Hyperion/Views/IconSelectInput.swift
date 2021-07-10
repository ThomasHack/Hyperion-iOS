//
//  IconSelectInput.swift
//  Hyperion
//
//  Created by Hack, Thomas on 09.02.21.
//  Copyright © 2021 Hack, Thomas. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import HyperionApi

struct IconSelectInput: View {
    let store: Store<Settings.SettingsFeatureState, Settings.Action>

    let instance: HyperionApi.Instance

    let availableImages = ["ambilight", "hue-bulb", "hue-playbars", "hue-lightstrip"]

    @State var expanded = false
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            HStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    SectionHeader(text: "\(instance.friendlyName)")
                }
                .padding(8)

                Spacer()

                VStack(alignment: .center, spacing: 0) {
                    if let image = viewStore.icons?[instance.friendlyName] {
                        Image(image)
                            .resizable()
                            .padding(2)
                            .clipped()
                            .cornerRadius(6)
                    }
                }
                .frame(width: 40, height: 40, alignment: .center)
            }
        }
    }
}

// viewStore.send(Settings.Action.iconNameChanged(instance: instance.friendlyName, iconName: image))

struct IconSelectInput_Previews: PreviewProvider {
    static var previews: some View {
        IconSelectInput(store: Main.previewStoreSettings,
                        instance: HyperionApi.Instance(instance: 0, running: true, friendlyName: "Instance #1")
        )
        .previewLayout(.fixed(width: 320, height: 100))
    }
}
