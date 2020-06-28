//
//  HomeView.swift
//  Hyperion
//
//  Created by Hack, Thomas on 26.06.20.
//  Copyright © 2020 Hack, Thomas. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

struct HomeView: View {
    let store: Store<Home.State, Home.Action>

    var body: some View {
        WithViewStore(self.store) { viewStore in
            NavigationView {
                ScrollView {
                    VStack(alignment: .leading, spacing: 8) {

                        ConnectionHeader(store: store)

                        InstanceSelection(store: store)

                        BrightnessControl(store: store)

                        InstanceControl(store: store)

                        IntensityControl(store: store)

                        Spacer()
                    }
                    .padding()
                }
                .background(Color(.secondarySystemBackground))
                .edgesIgnoringSafeArea(.all)
                .padding([.top], 10)
                .onAppear {
                    viewStore.send(.connectButtonTapped)
                }
                .navigationBarTitle(Text("Hue Sync"), displayMode: .automatic)
                .navigationBarItems(
                    trailing:
                        HStack(spacing: 24) {
                            Button(action: { viewStore.send(.connectButtonTapped) }) {
                                Image(systemName: viewStore.connectivityState == .connected
                                        ? "bolt.fill"
                                        : viewStore.connectivityState == .disconnected
                                        ? "bolt.slash.fill"
                                        : "bolt")
                                    .imageScale(.large)
                            }
                            Button(action: { viewStore.send(.settingsButtonTapped) }) {
                                Image(systemName: "gear")
                                    .imageScale(.large)
                            }
                        }
                )
                .sheet(isPresented: viewStore.binding( get: { $0.showSettingsModal }, send: Home.Action.didUpdateSettingsModal )) {
                    SettingsView(
                        store: Main.initialStore.settingsStore
                    )
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {

    static var previews: some View {
        HomeView(
            store: Store(
                initialState: Home.previewState,
                reducer: Home.reducer,
                environment: Main.initialEnvironment
            )
        )
    }
}
