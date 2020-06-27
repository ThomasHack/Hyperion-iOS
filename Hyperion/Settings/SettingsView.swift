//
//  Settings.swift
//  Hyperion
//
//  Created by Hack, Thomas on 27.06.20.
//  Copyright © 2020 Hack, Thomas. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

struct SettingsView: View {
    let store: Store<SettingsState, SettingsAction>

    @Binding var showSettingsModal: Bool

    var body: some View {
        WithViewStore(self.store) { viewStore in
            NavigationView {
                VStack(alignment: .leading, spacing: 8) {
                    SectionHeader(text: "Host")
                    TextField("https://hyperion.home:8090",
                              text: viewStore.binding( get: { $0.hostnameInput}, send: SettingsAction.hostInputTextChanged))
                    Spacer()
                }
                .padding()
                .navigationBarTitle(Text("Settings"), displayMode: .large)
                .background(Color(.secondarySystemBackground))
                .edgesIgnoringSafeArea(.all)
                .padding([.top], 10)
                .navigationBarItems(
                    trailing:
                        HStack(spacing: 16) {
                            Button(action: { self.showSettingsModal = false }) {
                                Text("Done")
                                    .font(.system(size: 17, weight: .bold))
                            }
                        }
                )
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    @State static var showSettingsModal = false

    static var previews: some View {
        SettingsView(
            store: Store(
                initialState: SettingsState(),
                reducer: settingsReducer,
                environment: MainEnvironment(
                    mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
                    apiClient: .live
                )
            ),
            showSettingsModal: $showSettingsModal
        )
    }
}
