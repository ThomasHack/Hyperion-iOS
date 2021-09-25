//
//  ConnectButton.swift
//  Hyperion
//
//  Created by Thomas Hack on 10.07.21.
//  Copyright © 2021 Hack, Thomas. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

struct ConnectButton: View {
    let store: Store<Settings.SettingsFeatureState, Settings.Action>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            Button(action: {
                viewStore.send(.connectButtonTapped)
            }) {
                HStack(alignment: .center) {
                    Spacer()
                    if viewStore.api.connectivityState == .disconnected {
                        Text("Connect")
                    } else {
                        Text("Disconnect")
                            .foregroundColor(.red)
                    }
                    Spacer()
                }
            }
        }
    }
}
