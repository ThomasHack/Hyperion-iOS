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
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {

                    ConnectionHeader(store: store)

                    Spacer()
                        .frame(height: 16.0)

                    InstanceSelection(store: store)

                    Spacer()
                        .frame(height: 16.0)

                    BrightnessControl(store: store)

                    Spacer()
                        .frame(height: 16.0)

                    InstanceControl(store: store)

                    Spacer()
                        .frame(height: 16.0)

                    IntensityControl(store: store)

                    Spacer()
                }
                .padding()
            }
            .background(Color(.secondarySystemBackground))
            .edgesIgnoringSafeArea(.all)
            .padding([.top], 10)
            .onAppear { viewStore.send(Home.Action.connectButtonTapped) }
            .navigationBarTitle(Text("Hue Sync"), displayMode: .automatic)
            .navigationBarItems(
                trailing:
                    HStack(spacing: 16) {
                        Button(action: { viewStore.send(Home.Action.connectButtonTapped) }) {
                            Image(systemName: viewStore.connectivityState == .connected
                                    ? "bolt.fill"
                                    : viewStore.connectivityState == .disconnected
                                    ? "bolt.slash.fill"
                                    : "bolt")
                                .imageScale(.large)
                        }
                        Button(action: { viewStore.send(Home.Action.settingsButtonTapped) }) {
                            Image(systemName: "gear")
                                .imageScale(.large)
                        }
                    }
            )
            .sheet(isPresented: viewStore.binding( get: { $0.showSettingsModal }, send: Home.Action.didUpdateSettingsModal )) {
                SettingsView(
                    store: Main.initialStore.settingsStore,
                    showSettingsModal: viewStore.binding( get: { $0.showSettingsModal }, send: Home.Action.didUpdateSettingsModal)
                )
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {

    static var previews: some View {
        HomeView(
            store: Main.initialStore.homeStore
        )
    }
}
