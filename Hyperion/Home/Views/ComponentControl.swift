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

    let columns = [
        GridItem(.adaptive(minimum: UIDevice.current.userInterfaceIdiom == .pad ? 200 : 100))
    ]

    var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack(alignment: .leading, spacing: 8) {
                SectionHeader(text: "Settings")

                LazyVGrid(columns: columns, spacing: 8) {

                    InstanceButton(
                        imageName: "hdr-tone-mapping",
                        text: "HDR Tone Mapping",
                        isDisabled: !viewStore.api.allEnabled,
                        isRunning: viewStore.api.hdrToneMapping,
                        callback: {
                            viewStore.send(.toggleHdrToneMapping(!viewStore.api.hdrToneMapping))
                        })

                    if let smoothing = viewStore.api.smoothingComponent {
                        InstanceButton(
                            imageName: "smoothing",
                            text: "Smoothing",
                            isDisabled: !viewStore.api.allEnabled,
                            isRunning: smoothing.enabled,
                            callback: {
                                viewStore.send(.toggleSmoothing(!smoothing.enabled))
                            })
                    }

                    if let blackborderDetection = viewStore.api.blackborderComponent {
                        InstanceButton(
                            imageName: "blackborder",
                            text: "Blackborder Detection",
                            isDisabled: !viewStore.api.allEnabled,
                            isRunning: blackborderDetection.enabled,
                            callback: {
                                viewStore.send(.toggleBlackborderDetection(!blackborderDetection.enabled))
                            })
                    }

                    if let v4l = viewStore.api.v4lComponent {
                        InstanceButton(
                            imageName: "v4l-hardware",
                            text: "HDMI Grabber",
                            isDisabled: !viewStore.api.allEnabled,
                            isRunning: v4l.enabled,
                            callback: {
                                viewStore.send(.toggleHdmiGrabber(!v4l.enabled))
                            })
                    }

                    if let led = viewStore.api.ledComponent {
                        InstanceButton(
                            imageName: "led-hardware",
                            text: "LED Hardware",
                            isDisabled: !viewStore.api.allEnabled,
                            isRunning: led.enabled,
                            callback: {
                                viewStore.send(.toggleLedHardware(!led.enabled))
                            })
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
