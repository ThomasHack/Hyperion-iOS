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
    static let backgroundDefaultsKeyName = "hyperion.background"
    static let iconNamesDefaultsKeyName = "hyperion.instanceIcons"
    static let instanceNamesDefaultsKeyName = "hyperion.instanceNames"
    static let backgroundImageDefaultsKeyName = "hyperion.backgroundImage"

    static let userDefaults = UserDefaults(suiteName: appGroupName)

    struct State: Equatable {
        var host: String? {
            didSet {
                userDefaults?.set(host, forKey: hostDefaultsKeyName)
            }
        }
        var icons: [Int: String] {
            didSet {
                guard let data = try? NSKeyedArchiver.archivedData(withRootObject: icons,
                                                                   requiringSecureCoding: false) else { return }
                userDefaults?.set(data, forKey: iconNamesDefaultsKeyName)
            }
        }

        var instanceNames: [Int: String] {
            didSet {
                guard let data = try? NSKeyedArchiver.archivedData(withRootObject: instanceNames,
                                                                   requiringSecureCoding: false) else { return }
                userDefaults?.set(data, forKey: instanceNamesDefaultsKeyName)
            }
        }

        var backgroundImage: String? {
            didSet {
                userDefaults?.set(backgroundImage, forKey: backgroundImageDefaultsKeyName)
            }
        }
        var showSettingsModal = false
    }

    static func fetchDictionaryUserDefaults(for key: String) -> [Int: String] {
        guard let unarchivedObject = userDefaults?.data(forKey: key) else { return [:] }
        do {
            //  swiftlint:disable line_length
            guard let dictionary = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(unarchivedObject) as? [Int: String] else {
                return [:]
            }
            return dictionary
        } catch {
            assertionFailure("fetchDictionaryUserDefaults")
        }
        return [:]
    }

    static let initialState = State(
        host: userDefaults?.string(forKey: hostDefaultsKeyName),
        icons: fetchDictionaryUserDefaults(for: iconNamesDefaultsKeyName),
        instanceNames: fetchDictionaryUserDefaults(for: instanceNamesDefaultsKeyName),
        backgroundImage: userDefaults?.string(forKey: backgroundImageDefaultsKeyName)
    )

    enum Action {
        case updateHost(String)
        case updateIcons([Int: String])
        case updateIcon(Int, String)
        case updateInstanceName(Int, String)
        case updateInstanceNames([Int: String])
        case updateBackgroundImage(String)
        case showSettingsModal
        case hideSettingsModal
        case toggleSettingsModal(Bool)
    }

    typealias Environment = Main.Environment

    static let reducer = Reducer<State, Action, Environment> { state, action, _ in
        switch action {
        case .updateHost(let string):
            state.host = string
        case let .updateIcon(instanceId, iconName):
            state.icons[instanceId] = iconName
        case .updateIcons(let icons):
            state.icons = icons
        case let .updateInstanceName(instanceId, instanceName):
            state.instanceNames[instanceId] = instanceName
        case .updateInstanceNames(let instanceNames):
            state.instanceNames = instanceNames
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
}
