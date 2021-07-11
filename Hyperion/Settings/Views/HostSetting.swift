//
//  HostSetting.swift
//  Hyperion
//
//  Created by Thomas Hack on 10.07.21.
//  Copyright © 2021 Hack, Thomas. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

struct HostSetting: View {
    let store: Store<Settings.SettingsFeatureState, Settings.Action>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            Section(header: Text("Host")) {
                VStack(alignment: .leading) {
                    SectionHeader(text: "Host")
                    TextField("https://hyperion.home:8090",
                              text: viewStore.binding(
                                get: { $0.hostInput },
                                send: Settings.Action.hostInputTextChanged)
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
