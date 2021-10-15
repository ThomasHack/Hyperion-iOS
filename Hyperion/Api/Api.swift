//
//  Api.swift
//  Hyperion
//
//  Created by Hack, Thomas on 26.06.20.
//  Copyright © 2020 Hack, Thomas. All rights reserved.
//

import Combine
import ComposableArchitecture
import Foundation
import HyperionApi
import SwiftUI
import UIKit

struct ApiId: Hashable {}

enum Api {
    typealias Environment = Main.Environment

    static let initialState = State()

    static let previewState = State(
        connectivityState: .connected,
        hostname: "Preview",
        instances: [
            HyperionApi.Instance(instance: 0, running: true, friendlyName: "LG OLED Ambilight"),
            HyperionApi.Instance(instance: 1, running: false, friendlyName: "Hue Sync"),
            HyperionApi.Instance(instance: 1, running: false, friendlyName: "Hue Play Lightbars")
        ],
        effects: [
            HyperionApi.LightEffect(name: "Atomic swirl"),
            HyperionApi.LightEffect(name: "Blue mood blobs"),
            HyperionApi.LightEffect(name: "Breath"),
            HyperionApi.LightEffect(name: "Cold mood blobs"),
            HyperionApi.LightEffect(name: "Full color mood blobs"),
            HyperionApi.LightEffect(name: "Knight rider"),
            HyperionApi.LightEffect(name: "Light clock"),
            HyperionApi.LightEffect(name: "Pac-Man"),
            HyperionApi.LightEffect(name: "Police Lights Solid"),
            HyperionApi.LightEffect(name: "Sea waves"),
            HyperionApi.LightEffect(name: "Strobe red"),
            HyperionApi.LightEffect(name: "Waves with Color")
        ],
        components: [
            HyperionApi.Component(name: .blackborder, enabled: true),
            HyperionApi.Component(name: .smoothing, enabled: true),
            HyperionApi.Component(name: .led, enabled: true),
            HyperionApi.Component(name: .v4l, enabled: true)
        ],
        hdrToneMapping: false,
        brightness: 65,
        selectedInstance: 0
    )
}
