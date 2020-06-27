//
//  AppView.swift
//  Hyperion
//
//  Created by Hack, Thomas on 26.06.20.
//  Copyright © 2020 Hack, Thomas. All rights reserved.
//

import Combine
import ComposableArchitecture
import Starscream
import SwiftUI

struct AppView: View {
    let store: Store<AppState, AppAction>

    var body: some View {
        WithViewStore(self.store) { viewStore in
            NavigationView {
                ZStack {
                    Color(UIColor.secondarySystemBackground)

                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            Text(
                            viewStore.connectivityState == .connected
                                ? "Status: Connected to \(viewStore.hostname)"
                                : viewStore.connectivityState == .disconnected
                                ? "Status: Disconnected"
                                : "Status: Connecting...")
                                .font(.system(size: 13))
                                .frame(maxWidth: .infinity, alignment: .center)

                            VStack(alignment: .leading) {
                                SectionHeader(text: "Intensity")
                                HStack(alignment: .center, spacing: 8.0) {
                                    IntensityButton(imageName: "rays", text: "Subtle", callback: {})
                                    IntensityButton(imageName: "slowmo", text: "Moderate", callback: {})
                                    IntensityButton(imageName: "wind", text: "High", callback: {})
                                    IntensityButton(imageName: "tornado", text: "Extreme", callback: {})
                                }
                            }
                            Spacer().frame(height: 30.0)
                            HStack(alignment: .center, spacing: 16) {
                                ForEach(viewStore.instances.filter { $0.running }, id: \.self) {instance in
                                    Button(action: {
                                        viewStore.send(.selectInstance(instance.instance))
                                    }) {
                                        Text("\(instance.friendlyName)")
                                        if instance.instance == viewStore.selectedInstance {
                                            Image(systemName: "checkmark.circle.fill")
                                        }
                                    }
                                }
                            }
                            VStack(alignment: .leading) {
                                SectionHeader(text: "Brightness \(viewStore.brightness)")
                                VStack(alignment: .center, spacing: 8.0) {
                                    BrightnessSlider(percentage: viewStore.binding( get: { $0.brightness }, send: AppAction.updateBrightness))
                                        .frame(height: 72)
                                }
                            }
                            Spacer().frame(height: 30.0)
                            VStack(alignment: .leading) {
                                SectionHeader(text: "Instances")
                                HStack {
                                    ForEach(viewStore.instances, id: \.self) {instance in
                                        IntensityButton(imageName: instance.friendlyName == "LG OLED Ambilight" ? "tv" : "lightbulb", text: instance.friendlyName, running: instance.running, callback: {
                                            viewStore.send(.instanceButtonTapped(instance.instance, instance.running))
                                        })
                                    }
                                }
                            }
                            Spacer()
                        }.padding()
                    }
                }
                .navigationBarTitle(Text("Hue Sync"), displayMode: .large)
                .background(Color(.secondarySystemBackground))
                .edgesIgnoringSafeArea(.all)
                .padding([.top], 10)
                .navigationBarItems(trailing:
                    Button(action: {
                        viewStore.send(.connectButtonTapped)
                    }) {
                        Text(
                            viewStore.connectivityState == .connected
                                ? "Disconnect"
                                : viewStore.connectivityState == .disconnected ? "Connect" : "Connecting...")
                    }
                )
            }.onAppear {
                viewStore.send(.connectButtonTapped)
            }
        }
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView(
            store: Store(
                initialState: AppState(
                    connectivityState: .connected,
                    receivedMessages: [],
                    brightness: 55,
                    hostname: "Preview",
                    instances: [
                        Instance(instance: 0, running: true, friendlyName: "LG OLED TV"),
                        Instance(instance: 1, running: true, friendlyName: "Hue Sync")
                    ]
                ),
                reducer: appReducer,
                environment: AppEnvironment(
                    mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
                    apiClient: .live
                )
            )
        )
    }
}
