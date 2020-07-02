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
    }

    enum Action {
        case hostInputTextChanged(String)
        case saveHostButtonTapped
        case hideSettingsModal

        case shared(Shared.Action)
    }

    typealias Environment = Main.Environment

    static let reducer = Reducer<SettingsFeatureState, Action, Environment>.combine(
        Reducer { state, action, environment in
            switch action {
            case .hostInputTextChanged(let text):
                state.hostInput = text
            case .hideSettingsModal:
                state.showSettingsModal = false
            case .saveHostButtonTapped:
                state.shared.host = state.hostInput
            case .shared:
                break
            }
            return .none
        },
        Shared.reducer.pullback(
            state: \SettingsFeatureState.shared,
            action: /Action.shared,
            environment: { $0 }
        )
    )
    static let initialState = State(
        hostInput: UserDefaults.standard.string(forKey: Shared.hostDefaultsKeyName) ?? ""
    )
}
