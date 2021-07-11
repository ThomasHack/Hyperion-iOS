//
//  Settings.swift
//  Hyperion
//
//  Created by Hack, Thomas on 27.06.20.
//  Copyright © 2020 Hack, Thomas. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import HyperionApi

struct SettingsView: View {
    let store: Store<Settings.SettingsFeatureState, Settings.Action>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            NavigationView {
                VStack {
                    List {
                        HostSetting(store: self.store)
                        
                        Section(header: Text("Icons")) {
                        if viewStore.instances.count > 0 {
                            ForEach(viewStore.api.instances, id: \.self) { instance in
                                    NavigationLink(
                                        destination:
                                            IfLetStore(self.store.scope(state: { $0.selection?.value }, action: Settings.Action.instanceEdit)) { childStore in
                                                InstanceEditView(store: childStore)
                                            },
                                            tag: instance.id,
                                            selection: viewStore.binding(get: { $0.selection?.id }, send: Settings.Action.setSelection)
                                    ) {
                                        IconSelectInput(store: self.store, instance: instance)
                                    }
                                }
                                .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                            }
                        }
                        
                        BackgroundSetting(store: self.store)
                        
                        ConnectButton(store: self.store)
                    }
                    .listRowBackground(Color.green)
                    // .listStyle(InsetGroupedListStyle())
                }
                .navigationBarTitle(Text("Settings"), displayMode: .large)
                .background(Color(.systemBackground))
                .edgesIgnoringSafeArea(.all)
                .padding([.top], 10)
                .navigationBarItems(
                    trailing:
                        HStack(spacing: 16) {
                    Button(action: {
                        viewStore.send(.doneButtonTapped)
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
