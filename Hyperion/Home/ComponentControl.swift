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
            GridItem(.adaptive(minimum: 150))
        ]
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack(alignment: .leading, spacing: 8) {
                SectionHeader(text: "Components")

                LazyVGrid(columns: columns, spacing: 8) {
                    InstanceButton(
                        imageName: "hdr-tone-mapping",
                        text: "HDR Tone Mapping",
                        isDisabled: false,
                        isRunning: viewStore.api.hdrToneMapping,
                        callback: {
                            viewStore.send(viewStore.api.hdrToneMapping ? .turnOffHdrToneMapping : .turnOnHdrToneMapping)
                        })
                    
                    if let blackborderDetection = viewStore.api.blackborderComponent {
                        InstanceButton(
                            imageName: "blackborder",
                            text: "Blackborder Detection",
                            isDisabled: false,
                            isRunning: blackborderDetection.enabled,
                            callback: {
                                viewStore.send(blackborderDetection.enabled ? .turnOffBlackborderDetection : .turnOnBlackborderDetection)
                            })
                    }

                    if let smoothing = viewStore.api.smoothingComponent {
                        InstanceButton(
                            imageName: "smoothing",
                            text: "Smoothing",
                            isDisabled: false,
                            isRunning: smoothing.enabled,
                            callback: {
                                viewStore.send(smoothing.enabled ? .turnOffSmoothing : .turnOnSmoothing)
                            })
                    }

                    if let led = viewStore.api.ledComponent {
                        InstanceButton(
                            imageName: "led-hardware",
                            text: "LED Hardware",
                            isDisabled: false,
                            isRunning: led.enabled,
                            callback: {
                                viewStore.send(led.enabled ? .turnOffLedHardware : .turnOnLedHardware)
                            })
                    }

                    if let v4l = viewStore.api.v4lComponent {
                        InstanceButton(
                            imageName: "v4l-hardware",
                            text: "HDMI Grabber",
                            isDisabled: false,
                            isRunning: v4l.enabled,
                            callback: {
                                viewStore.send(v4l.enabled ? .turnOffHdmiGrabber : .turnOnHdmiGrabber)
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
