//
//  Shared.swift
//  Hyperion
//
//  Created by Hack, Thomas on 28.06.20.
//  Copyright © 2020 Hack, Thomas. All rights reserved.
//

import ComposableArchitecture
import Foundation

enum Shared {
    struct State: Equatable {
        var host: String? {
            didSet {
                UserDefaults.standard.set(host, forKey: hostDefaultsKeyName)
                // UserDefaults.standard.setValue(host, forKey: Shared.hostDefaultsKeyName)
            }
        }
        var icons: [String: String]? {
            didSet {
                UserDefaults.standard.set(icons, forKey: iconsDefaultsKeyName)
            }
        }
        var showSettingsModal: Bool = false
    }

    static let hostDefaultsKeyName = "hyperion.hostname"
    static let iconsDefaultsKeyName = "hyperion.instanceIcons"

    static let initialState = State(
        host: UserDefaults.standard.string(forKey: hostDefaultsKeyName),
        icons: UserDefaults.standard.value(forKey: iconsDefaultsKeyName) as? [String: String] ?? [:]
    )

    enum Action {
        case updateHost(String)
        case updateIcons([String: String])
        case showSettingsModal
        case hideSettingsModal
        case toggleSettingsModal(Bool)
    }

    typealias Environment = Main.Environment

    static let reducer = Reducer<State, Action, Environment> { state, action, environment in
        switch action {
        case .updateHost(let string):
            state.host = string
        case .updateIcons(let icons):
            state.icons = icons
        case .showSettingsModal:
            state.showSettingsModal = true
        case .hideSettingsModal:
            state.showSettingsModal = false
        case .toggleSettingsModal(let toggle):
            state.showSettingsModal = toggle
        }
        return .none
    }
    // .debug()
}
