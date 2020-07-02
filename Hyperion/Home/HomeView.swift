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
    let store: Store<Home.HomeFeatureState, Home.Action>

    var body: some View {
        WithViewStore(self.store) { viewStore in
            NavigationView {
                VStack(alignment: .leading, spacing: 0) {
                    if viewStore.connectivityState == .connected {
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
                    }
                    else {
                        VStack {
                            ZStack {
                                Color(.secondarySystemBackground)
                                HStack(alignment: .center) {
                                    VStack(alignment: .center, spacing: 8) {
                                        HStack() {
                                            Image(systemName: "bolt.slash.fill")
                                            Text("Not Connected")
                                        }.foregroundColor(.secondary)
                                        Button(action: {
                                            viewStore.send(.settingsButtonTapped)
                                        }) {
                                            Text("Connect")
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .background(Color(.secondarySystemBackground))
                .edgesIgnoringSafeArea(.all)
                .padding([.top], 10)
                .navigationBarTitle(Text("Hue Sync"), displayMode: .automatic)
                .navigationBarItems(
                    trailing:
                        HStack(spacing: 24) {
                            Button(action: {
                                viewStore.send(.connectButtonTapped)
                            }) {
                                Image(systemName: viewStore.connectivityState == .connected
                                        ? "bolt.fill"
                                        : viewStore.connectivityState == .disconnected
                                        ? "bolt.slash.fill"
                                        : "bolt")
                                   .imageScale(.large)
                            }
                            Button(action: {
                                viewStore.send(.settingsButtonTapped)
                            }) {
                                Image(systemName: "gear")
                                    .imageScale(.large)
                            }
                        }
                )
                .sheet(isPresented: viewStore.binding(
                        get: { $0.shared.showSettingsModal },
                        send: Home.Action.toggleSettingsModal)
                ) {
                    SettingsView(store: Main.store.settings)
                }
                .onAppear {
                    if viewStore.shared.host != nil && viewStore.connectivityState == .disconnected {
                        viewStore.send(.connectButtonTapped)
                    }
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {

    static var previews: some View {
        HomeView(store: Main.previewStoreHome)
    }
}
