//
//  InstanceEdit+InstanceEditFeature.swift
//  Hyperion
//
//  Created by Hack, Thomas on 01.07.20.
//  Copyright © 2020 Hack, Thomas. All rights reserved.
//

import Foundation

extension InstanceEdit {
    @dynamicMemberLookup
    struct InstanceEditFeatureState: Equatable {
        var instanceEdit: InstanceEdit.State
        var shared: Shared.State
        var settings: Settings.State

        public subscript<T>(dynamicMember keyPath: WritableKeyPath<InstanceEdit.State, T>) -> T {
            get { instanceEdit[keyPath: keyPath] }
            set { instanceEdit[keyPath: keyPath] = newValue }
        }

        public subscript<T>(dynamicMember keyPath: WritableKeyPath<Shared.State, T>) -> T {
            get { shared[keyPath: keyPath] }
            set { shared[keyPath: keyPath] = newValue }
        }

        public subscript<T>(dynamicMember keyPath: WritableKeyPath<Settings.State, T>) -> T {
            get { settings[keyPath: keyPath] }
            set { settings[keyPath: keyPath] = newValue }
        }
    }

    static let previewState = InstanceEditFeatureState(
        instanceEdit: InstanceEdit.State(),
        shared: Shared.State(
            host: "http://preview.host",
            showSettingsModal: false
        ),
        settings: Settings.State()
    )
}
