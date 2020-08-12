//
//  ComponentControl.swift
//  Hyperion
//
//  Created by Hack, Thomas on 27.06.20.
//  Copyright © 2020 Hack, Thomas. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

struct ComponentControl: View {
    let store: Store<Home.HomeFeatureState, Home.Action>

    var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack(alignment: .leading, spacing: 8) {
                SectionHeader(text: "Components")

                HStack(alignment: .center, spacing: 8.0) {
                    if let blackborderDetection = viewStore.api.blackborderComponent {
                        InstanceButton(
                            imageName: "Blackborder",
                            text: "Blackborder Detection",
                            isDisabled: false,
                            isRunning: blackborderDetection.enabled,
                            callback: {
                                viewStore.send(blackborderDetection.enabled ? .turnOffBlackborderDetection : .turnOnBlackborderDetection)
                            })
                    } else {
                        Text("Blackborder Detection unavailable")
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    if let smoothing = viewStore.api.smoothingComponent {
                        InstanceButton(
                            imageName: "Smoothing",
                            text: "Smoothing",
                            isDisabled: false,
                            isRunning: smoothing.enabled,
                            callback: {
                                viewStore.send(smoothing.enabled ? .turnOffSmoothing : .turnOnSmoothing)
                            })
                    } else {
                        Text("Smoothing unavailable")
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }

                Spacer()
                    .frame(height: 16.0)
            }
        }
    }
}

struct ComponentControl_Previews: PreviewProvider {
    static var previews: some View {
        ComponentControl(store: Main.store.home)
        .previewLayout(.fixed(width: 375, height: 160))
    }
}
