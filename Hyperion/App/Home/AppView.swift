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

    @State var brightness: Double = 0

    var body: some View {
        WithViewStore(self.store) { viewStore in
            NavigationView {
                ZStack {
                    Color(UIColor.secondarySystemBackground)
                    VStack(alignment: .leading, spacing: 16) {
                        VStack(alignment: .leading) {
                            SectionHeader(text: "Intensity")
                            HStack(alignment: .center, spacing: 8.0) {
                                IntensityButton(imageName: "rays", text: "Subtle", callback: {})
                                IntensityButton(imageName: "slowmo", text: "Moderate", callback: {})
                                IntensityButton(imageName: "wind", text: "High", callback: {})
                                IntensityButton(imageName: "tornado", text: "Extreme", callback: {})
                            }
                        }
                        Spacer().frame(height: 40.0)
                        VStack(alignment: .leading) {
                            SectionHeader(text: "Brightness \(viewStore.brightness)")
                            Slider(value: viewStore.binding(
                                get: { $0.brightness }, send: AppAction.updateBrightness(5)
                            ), in: 0...100, step: 1)
                            VStack(alignment: .center, spacing: 8.0) {
                                BrightnessSlider(percentage: self.$brightness)
                                    .didChange {
                                        viewStore.send(.updateBrightness(self.$brightness.wrappedValue))
                                    }
                                    .frame(height: 72)
                            }
                        }
                        Spacer().frame(height: 40.0)
                        VStack(alignment: .leading) {
                            SectionHeader(text: "Instances")
                            HStack {
                                ForEach(viewStore.instances) {instance in
                                    IntensityButton(imageName: "tornado", text: instance.friendlyName, callback: {})
                                }
                            }
                        }
                        Spacer()
                    }.padding()
                }
                .navigationBarTitle(Text("Hue Sync \(viewStore.hostname)"), displayMode: .large)
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
                initialState: AppState(),
                reducer: appReducer,
                environment: AppEnvironment(
                    mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
                    apiClient: .live
                )
            )
        )
    }
}
