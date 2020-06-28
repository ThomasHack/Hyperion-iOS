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
        var showSettingsModal: Bool = false
        var hostInput: String = ""
    }

    enum Action {
        case hostInputTextChanged(String)
        case toggleSettingsModal
    }

    typealias Environment = Main.Environment

    static let reducer = Reducer<Settings.State, Settings.Action, Settings.Environment> { state, action, environment in
        switch action {
        case .hostInputTextChanged(let text):
            state.hostInput = text
        case .toggleSettingsModal:
            state.showSettingsModal.toggle()
        }
        return .none
    }

    static let initialState = State(
        showSettingsModal: false,
        hostInput: ""
    )
}
