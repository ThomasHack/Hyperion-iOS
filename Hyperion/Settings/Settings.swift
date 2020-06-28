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
        var showSettingsModal = false
        var hostInput: String?
        var host: String?
    }

    enum Action {
        case closeSettingsModal
        case hostInputTextChanged(String)
        case saveHostButtonTapped
    }

    typealias Environment = Main.Environment

    static let reducer = Reducer<State, Action, Environment> { state, action, environment in
        switch action {
        case .closeSettingsModal:
            state.showSettingsModal = false
        case .hostInputTextChanged(let text):
            state.hostInput = text
        case .saveHostButtonTapped:
            state.host = state.hostInput
            environment.defaults.set(state.hostInput, forKey: Main.hostDefaultsKeyName)
        }
        return .none
    }

    static let initialState = State(
        showSettingsModal: false,
        hostInput: UserDefaults.standard.string(forKey: Main.hostDefaultsKeyName)
    )
}
