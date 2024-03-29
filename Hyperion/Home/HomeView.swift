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

    init(store: Store<Home.HomeFeatureState, Home.Action>) {
        self.store = store

        UINavigationBar.appearance().scrollEdgeAppearance = Appearance.transparentAppearance
        UINavigationBar.appearance().standardAppearance = Appearance.transparentAppearance
    }

    var body: some View {
        WithViewStore(self.store) { viewStore in
            NavigationView {
                ZStack {
                    Color(UIColor.systemBackground)

                    if viewStore.connectivityState == .connected {
                        ScrollView {
                            VStack(alignment: .leading, spacing: 8) {

                                ConnectionHeader(store: store)

                                InstanceSelection(store: store)

                                BrightnessControl(store: store)

                                InstanceControl(store: store)

                                ComponentControl(store: store)

                                Spacer(minLength: 0)
                            }
                            .padding()
                        }
                    } else {
                        NotConnected(store: store)
                    }
                }
                .edgesIgnoringSafeArea(.all)
                .padding([.top], 10)
                .navigationBarTitle(Text("Hue Sync"), displayMode: .automatic)
                .navigationBarItems(
                    trailing:
                        HStack(spacing: 24) {
                            Button {
                                if let all = viewStore.api.allComponent {
                                    viewStore.send(.powerButtonTapped(!all.enabled))
                                }
                            } label: {
                                Image(systemName: viewStore.api.allEnabled ? "power.circle" : "power.circle.fill")
                                    .imageScale(.large)
                            }
                            .foregroundColor(Color(.label))

                            Button {
                                viewStore.send(.settingsButtonTapped)
                            } label: {
                                Image(systemName: "gear")
                                    .imageScale(.large)
                            }
                            .foregroundColor(Color(.label))
                        }
                )
                .sheet(isPresented: viewStore.binding(
                    get: \.showSettingsModal,
                    send: Home.Action.toggleSettingsModal)
                ) {
                    SettingsView(store: Main.store.settings)
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}

struct HomeView_Previews: PreviewProvider {

    static var previews: some View {
        HomeView(store: Main.previewStoreHome)
            .preferredColorScheme(.light)
    }
}
