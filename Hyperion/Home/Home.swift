//
//  Home.swift
//  Hyperion
//
//  Created by Hack, Thomas on 26.06.20.
//  Copyright © 2020 Hack, Thomas. All rights reserved.
//

import ComposableArchitecture
import Foundation
import HyperionApi
import SwiftUI

enum Home {
    struct State: Equatable {}

    enum Action {
        case connectButtonTapped
        case settingsButtonTapped
        case powerButtonTapped(Bool)
        case instanceButtonTapped(Int, Bool)
        case toggleSettingsModal(Bool)

        case selectInstance(Int)
        case updateBrightness(Double)
        case updateColor(Color)
        case clearButtonTapped
        case toggleAll(Bool)
        case toggleSmoothing(Bool)
        case toggleBlackborderDetection(Bool)
        case toggleLedHardware(Bool)
        case toggleHdmiGrabber(Bool)
        case toggleHdrToneMapping(Bool)

        case api(Api.Action)
        case shared(Shared.Action)
    }

    typealias Environment = Main.Environment

    static let reducer = Reducer<HomeFeatureState, Action, Environment>.combine(
        Reducer { state, action, _ in
            switch action {
            case .connectButtonTapped:
                switch state.connectivityState {
                case .connected, .connecting:
                    return Effect(value: Action.api(.disconnect))

                case .disconnected:
                    guard let host = state.host, let url = URL(string: host) else { return .none }
                    return Effect(value: Action.api(.connect(url)))
                }

            case .settingsButtonTapped:
                return Effect(value: Action.shared(.showSettingsModal))

            case .powerButtonTapped(let toggle):
                return Effect(value: Action.api(.toggleAll(toggle)))

            case .toggleSettingsModal(let toggle):
                return Effect(value: Action.shared(.toggleSettingsModal(toggle)))

            case let .instanceButtonTapped(instanceId, running):
                return Effect(value: Action.api(.updateInstance(instanceId, !running)))

            case .selectInstance(let instanceId):
                return Effect(value: Action.api(.selectInstance(instanceId)))

            case .updateColor(let color):
                return Effect(value: Action.api(.updateColor(color.rgbColor)))

            case .updateBrightness(let brightness):
                return Effect(value: Action.api(.updateBrightness(brightness)))

            case .clearButtonTapped:
                return Effect(value: Action.api(.clear))

            case .toggleAll(let enable):
                return Effect(value: Action.api(.toggleAll(enable)))

            case .toggleSmoothing(let enable):
                return Effect(value: Action.api(.toggleSmoothing(enable)))

            case .toggleBlackborderDetection(let enable):
                return Effect(value: Action.api(.toggleBlackborderDetection(enable)))

            case .toggleHdrToneMapping(let enable):
                return Effect(value: Action.api(.toggleHdrToneMapping(enable)))

            case .toggleLedHardware(let enable):
                return Effect(value: Action.api(.toggleLedHardware(enable)))

            case .toggleHdmiGrabber(let enable):
                return Effect(value: Action.api(.toggleHdmiGrabber(enable)))

            case .api, .shared:
                return .none
            }
        },
        Shared.reducer.pullback(
            state: \HomeFeatureState.shared,
            action: /Action.shared,
            environment: { $0 }
        ),
        Api.reducer.pullback(
            state: \HomeFeatureState.api,
            action: /Action.api,
            environment: { $0 }
        )
    )

    static let initialState = State()
}
