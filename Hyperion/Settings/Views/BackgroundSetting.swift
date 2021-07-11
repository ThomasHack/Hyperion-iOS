//
//  BackgroundSetting.swift
//  Hyperion
//
//  Created by Thomas Hack on 10.07.21.
//  Copyright © 2021 Hack, Thomas. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

struct BackgroundSetting: View {
    let store: Store<Settings.SettingsFeatureState, Settings.Action>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            Section(header: Text("Background")) {
                VStack(alignment: .leading) {
                    SectionHeader(text: "Background Image")
                    TextField("Icon Name",
                              text: viewStore.binding(
                                get: { $0.backgroundImage },
                                send: Settings.Action.backgroundImageChanged
                              )
                    )
                    .keyboardType(.URL)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                }
                .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
            }
        }
    }
}
