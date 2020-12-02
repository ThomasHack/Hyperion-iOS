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
    let store: Store<Settings.SettingsFeatureState, Settings.Action>

    var body: some View {
        WithViewStore(self.store) { viewStore in
            NavigationView {
                VStack {
                    List {
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
                        }

                        if viewStore.instances.count > 0 {
                            Section(header: Text("Icons")) {
                                VStack(alignment: .leading, spacing: 16) {
                                    ForEach(viewStore.instances, id: \HyperionApi.Instance.self) { instance in
                                        VStack(alignment: .leading, spacing: 0) {
                                            SectionHeader(text: "\(instance.friendlyName)")
                                            TextField("Icon Name",
                                                      text: viewStore.binding(
                                                        get: { ($0.iconNames[instance.friendlyName] ?? "") },
                                                        send: { text in
                                                            Settings.Action.iconNameChanged(instance: instance.friendlyName, iconName: text)
                                                        }
                                                      )
                                                )
                                                .keyboardType(.URL)
                                                .disableAutocorrection(true)
                                                .autocapitalization(.none)
                                        }
                                    }
                                }
                            }
                        }

                        Section(header: Text("Background")) {
                            VStack(alignment: .leading, spacing: 0) {
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
                        }

                    }.listStyle(InsetGroupedListStyle())
                }
                .navigationBarTitle(Text("Settings"), displayMode: .large)
                .background(Color(.secondarySystemBackground))
                .edgesIgnoringSafeArea(.all)
                .padding([.top], 10)
                .navigationBarItems(
                    trailing:
                        HStack(spacing: 16) {
                            Button(action: {
                                viewStore.send(.doneButtonTapped)
                                viewStore.send(.hideSettingsModal)
                            }) {
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
    static var previews: some View {
        SettingsView(store: Main.previewStoreSettings)
    }
}
