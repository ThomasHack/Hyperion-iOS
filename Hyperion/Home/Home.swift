//
//  Home.swift
//  Hyperion
//
//  Created by Hack, Thomas on 26.06.20.
//  Copyright © 2020 Hack, Thomas. All rights reserved.
//

import ComposableArchitecture
import Foundation

enum Home {
    struct State: Equatable {}

    enum Action {
        case connectButtonTapped
        case settingsButtonTapped
        case powerButtonTapped
        case instanceButtonTapped(Int, Bool)
        case toggleSettingsModal(Bool)

        case selectInstance(Int)
        case updateBrightness(Double)
        case turnOnSmoothing
        case turnOffSmoothing
        case turnOnBlackborderDetection
        case turnOffBlackborderDetection

        case api(Api.Action)
        case shared(Shared.Action)
    }

    typealias Environment = Main.Environment

    static let reducer = Reducer<HomeFeatureState, Action, Environment>.combine(
        Reducer { state, action, environment in
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

            case .powerButtonTapped:
                if state.api.highestPriority?.componentId == HyperionApi.ComponentType.color {
                    return Effect(value: Action.api(.clear))
                }
                return Effect(value: Action.api(.updateColor(RGB(red: 0, green: 0, blue: 0))))

            case .toggleSettingsModal(let toggle):
                return Effect(value: Action.shared(.toggleSettingsModal(toggle)))

            case .instanceButtonTapped(let instanceId, let running):
                return Effect(value: Action.api(.updateInstance(instanceId, !running)))

            case .selectInstance(let instanceId):
                return Effect(value: Action.api(.selectInstance(instanceId)))

            case .updateBrightness(let brightness):
                return Effect(value: Action.api(.updateBrightness(brightness)))

            case .turnOnSmoothing:
                return Effect(value: Action.api(.turnOnSmoothing))

            case .turnOffSmoothing:
                return Effect(value: Action.api(.turnOffSmoothing))

            case .turnOnBlackborderDetection:
                return Effect(value: Action.api(.turnOnBlackborderDetection))

            case .turnOffBlackborderDetection:
                return Effect(value: Action.api(.turnOffBlackborderDetection))

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
    //.debug()

    static let initialState = State()
}