//
//  Settings.swift
//  Hyperion
//
//  Created by Hack, Thomas on 27.06.20.
//  Copyright © 2020 Hack, Thomas. All rights reserved.
//

import ComposableArchitecture
import Foundation

struct SettingsState: Equatable {
    var hostnameInput: String = ""
}

enum SettingsAction {
    case hostInputTextChanged(String)
}

let settingsReducer = Reducer<SettingsState, SettingsAction, MainEnvironment> { state, action, environment in
    switch action {
    case .hostInputTextChanged(let text):
        print("text: \(text)")
    }
    return .none
}
