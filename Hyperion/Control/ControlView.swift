//
//  ControlView.swift
//  Hyperion
//
//  Created by Hack, Thomas on 02.07.20.
//  Copyright © 2020 Hack, Thomas. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

struct ControlView: View {
    let store: Store<Control.ControlFeatureState, Control.Action>

    var body: some View {
        WithViewStore(self.store) { viewStore in
            NavigationView {
                VStack(alignment: .leading, spacing: 16) {
                    SectionHeader(text: "Color")
                        GeometryReader { (geometry) in
                            VStack(alignment: .leading, spacing: 16) {
                                ColourWheel(
                                    radius: geometry.size.width,
                                    rgbColour: viewStore.binding( get: { $0.rgbColor }, send: Control.Action.updateColor),
                                    brightness: viewStore.binding( get: { $0.brightness }, send: Control.Action.updateBrightness)
                                ).frame(height: geometry.size.width)

                                CustomSlider(
                                    rgbColour: viewStore.binding( get: { $0.rgbColor }, send: Control.Action.updateColor),
                                    value: viewStore.binding( get: { $0.brightness }, send: Control.Action.updateBrightness),
                                    range: 0.01...1
                                )
                            }
                        }

                        Spacer()
                }
                .padding(.all, 16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.secondarySystemBackground))
                .edgesIgnoringSafeArea(.all)
                .padding([.top], 10)
                .navigationBarTitle(Text("Control"), displayMode: .automatic)
                .navigationBarItems(
                    trailing:
                        HStack(spacing: 24) {
                            Button(action: {
                                viewStore.send(.clearButtonTapped)
                            }) {
                                HStack {
                                    Image(systemName: "clear")
                                        .imageScale(.large)
                                    Text("Clear")
                                }
                            }
                        }
                )
            }
        }
    }
}

struct ControlView_Previews: PreviewProvider {
    static var previews: some View {
        ControlView(store: Main.previewStoreControl)
    }
}
