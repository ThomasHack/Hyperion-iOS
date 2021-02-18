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
    static let appGroupName = "group.hyperion-ng"
    static let hostDefaultsKeyName = "hyperion.hostname"
    static let iconsDefaultsKeyName = "hyperion.instanceIcons"
    static let backgroundImageDefaultsKeyName = "hyperion.backgroundImage"

    static let userDefaults = UserDefaults(suiteName: appGroupName)

    struct State: Equatable {
        var host: String? {
            didSet {
                userDefaults?.set(host, forKey: hostDefaultsKeyName)
            }
        }
        var icons: [String: String]? {
            didSet {
                userDefaults?.set(icons, forKey: iconsDefaultsKeyName)
            }
        }

        var backgroundImage: String? {
            didSet {
                userDefaults?.set(backgroundImage, forKey: backgroundImageDefaultsKeyName)
            }
        }
        var showSettingsModal: Bool = false
    }

    static let initialState = State(
        host: userDefaults?.string(forKey: hostDefaultsKeyName),
        icons: userDefaults?.value(forKey: iconsDefaultsKeyName) as? [String: String] ?? [:],
        backgroundImage: userDefaults?.string(forKey: backgroundImageDefaultsKeyName)
    )

    enum Action {
        case updateHost(String)
        case updateIcons([String: String])
        case updateBackgroundImage(String)
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
        case .updateBackgroundImage(let string):
            state.backgroundImage = string
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
