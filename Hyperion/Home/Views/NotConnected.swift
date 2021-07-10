//
//  NotConnected.swift
//  Hyperion
//
//  Created by Hack, Thomas on 13.08.20.
//  Copyright © 2020 Hack, Thomas. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

struct NotConnected: View {
    let store: Store<Home.HomeFeatureState, Home.Action>

    var body: some View {
        WithViewStore(self.store) { viewStore in
            ZStack {
                Color(.secondarySystemBackground)
                HStack(alignment: .center) {
                    VStack(alignment: .center, spacing: 8) {
                        HStack() {
                            Image(systemName: "bolt.slash.fill")
                            Text("Not Connected")
                        }.foregroundColor(.secondary)
                        Button(action: {
                            if viewStore.shared.host != nil {
                                viewStore.send(.connectButtonTapped)
                            } else {
                                viewStore.send(.settingsButtonTapped)
                            }
                        }) {
                            Text(viewStore.shared.host != nil ? "Connect" : "Set Host")
                        }
                    }
                }
            }
        }
    }
}

struct NotConnected_Previews: PreviewProvider {
    static var previews: some View {
        NotConnected(store: Main.store.home)
    }
}
