//
//  AppView.swift
//  Hyperion
//
//  Created by Hack, Thomas on 13.06.20.
//  Copyright © 2020 Hack, Thomas. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

struct AppView: View {

    let store: Store<ApiState, ApiAction>

    @State var brightness: Int = 0

    var body: some View {
        WithViewStore(self.store) { viewStore in
            NavigationView {
                ZStack {
                    Color(UIColor.secondarySystemBackground)

                    VStack(alignment: .leading, spacing: 0) {

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
                            SectionHeader(text: "Brightness")

                            VStack(alignment: .center, spacing: 8.0) {
                                BrightnessSlider(percentage: self.$brightness)
                                    .didChange {
                                        // self.brightnessDidChange()
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
                    }
                    .padding()
                }
                .navigationBarTitle(Text("Hue Sync \(viewStore.hostname)"), displayMode: .large)
                .background(Color(.secondarySystemBackground))
                .edgesIgnoringSafeArea(.all)
                .padding([.top], 10)
                .navigationBarItems(trailing:
                    HStack {
                        Button(action: { viewStore.send(.connectButtonTapped)}, label: {
                            Text("Connect")
                        })
                    }
                )
            }
        }
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView(
            store: Store(
                initialState: ApiState(),
                reducer: apiReducer,
                environment: ApiEnvironment()
            )
        )
    }
}
