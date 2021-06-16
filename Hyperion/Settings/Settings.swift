//
//  Settings.swift
//  Hyperion
//
//  Created by Hack, Thomas on 27.06.20.
//  Copyright © 2020 Hack, Thomas. All rights reserved.
//

import ComposableArchitecture
import Foundation

enum Settings {
    struct State: Equatable {
        var hostInput: String = ""
        var iconNames: [String: String] = [:]
        var backgroundImage: String = ""
    }

    enum Action {
        case hostInputTextChanged(String)
        case iconNameChanged(instance: String, iconName: String)
        case backgroundImageChanged(String)
        case connectButtonTapped
        case doneButtonTapped
        case hideSettingsModal

        case api(Api.Action)
        case shared(Shared.Action)
    }

    typealias Environment = Main.Environment

    static let reducer = Reducer<SettingsFeatureState, Action, Environment>.combine(
        Reducer { state, action, environment in
            switch action {
            case .hostInputTextChanged(let text):
                state.hostInput = text
            case .iconNameChanged(let instance, let text):
                state.iconNames[instance] = text
                return Effect(value: .shared(.updateIcons(state.iconNames)))
            case .backgroundImageChanged(let text):
                state.backgroundImage = text
                return Effect(value: .shared(.updateBackgroundImage(state.backgroundImage)))
            case .connectButtonTapped:
                switch state.connectivityState {
                case .connected, .connecting:
                    return Effect(value: Action.api(.disconnect))

                case .disconnected:
                    guard let host = state.host, let url = URL(string: host) else { return .none }
                    return Effect(value: Action.api(.connect(url)))
                }
            case .hideSettingsModal:
                state.showSettingsModal = false
            case .doneButtonTapped:
                state.shared.host = state.hostInput
            case .shared, .api:
                break
            }
            return .none
        },
        Shared.reducer.pullback(
            state: \SettingsFeatureState.shared,
            action: /Action.shared,
            environment: { $0 }
        ),
        Api.reducer.pullback(
            state: \SettingsFeatureState.api,
            action: /Action.api,
            environment: { $0 }
        )
    )
    
    static let initialState = State(
        hostInput: UserDefaults.standard.string(forKey: Shared.hostDefaultsKeyName) ?? "",
        iconNames: UserDefaults.standard.value(forKey: Shared.iconsDefaultsKeyName) as? [String: String] ?? [:]
    )
}
