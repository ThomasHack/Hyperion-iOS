//
//  Settings+SettingsFeature.swift
//  Hyperion
//
//  Created by Hack, Thomas on 01.07.20.
//  Copyright © 2020 Hack, Thomas. All rights reserved.
//

import Foundation

extension Settings {
    @dynamicMemberLookup
    struct SettingsFeatureState: Equatable {
        var settings: Settings.State
        var shared: Shared.State

        public subscript<T>(dynamicMember keyPath: WritableKeyPath<Settings.State, T>) -> T {
            get { settings[keyPath: keyPath] }
            set { settings[keyPath: keyPath] = newValue }
        }

        public subscript<T>(dynamicMember keyPath: WritableKeyPath<Shared.State, T>) -> T {
            get { shared[keyPath: keyPath] }
            set { shared[keyPath: keyPath] = newValue }
        }
    }
}
