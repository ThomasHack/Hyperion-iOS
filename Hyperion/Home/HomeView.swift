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
    let store: Store<HomeState, HomeAction>

    @State var showSettingsModal = false

    var body: some View {
        WithViewStore(self.store) { viewStore in
            NavigationView() {
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
                .sheet(isPresented: self.$showSettingsModal) {
                    SettingsView(showSettingsModal: $showSettingsModal)
                }
                .navigationBarTitle(Text("Hue Sync"), displayMode: .automatic)
                .background(Color(.secondarySystemBackground))
                .edgesIgnoringSafeArea(.all)
                .padding([.top], 10)
                .navigationBarItems(
                    trailing:
                        HStack(spacing: 16) {
                            Button(action: { viewStore.send(.connectButtonTapped) }) {
                                Image(systemName: viewStore.connectivityState == .connected
                                        ? "bolt.fill"
                                        : viewStore.connectivityState == .disconnected
                                        ? "bolt.slash.fill"
                                        : "bolt")
                                    .imageScale(.large)
                            }
                            Button(action: { self.showSettingsModal.toggle() }) {
                                Image(systemName: "gear")
                                    .imageScale(.large)
                            }
                        }
                )
            }
            .onAppear { viewStore.send(.connectButtonTapped) }
        }
    }
}

struct HomeView_Previews: PreviewProvider {

    static var previews: some View {
        HomeView(
            store: Store(
                initialState: HomeState(
                    connectivityState: .connected,
                    receivedMessages: [],
                    brightness: 55,
                    hostname: "Preview",
                    instances: [
                        Instance(instance: 0, running: true, friendlyName: "LG OLED TV"),
                        Instance(instance: 1, running: false, friendlyName: "Hue Sync")
                    ]
                ),
                reducer: homeReducer,
                environment: MainEnvironment(
                    mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
                    apiClient: .live
                )
            ),
            showSettingsModal: false
        )
    }
}
