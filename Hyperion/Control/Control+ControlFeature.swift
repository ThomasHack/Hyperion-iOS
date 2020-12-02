//
//  Control+ControlFeature.swift
//  Hyperion
//
//  Created by Hack, Thomas on 02.07.20.
//  Copyright © 2020 Hack, Thomas. All rights reserved.
//

import ComposableArchitecture
import Foundation

extension Control {
    @dynamicMemberLookup
    struct ControlFeatureState: Equatable {
        var control: Control.State
        var api: Api.State

        public subscript<T>(dynamicMember keyPath: WritableKeyPath<Control.State, T>) -> T {
            get { control[keyPath: keyPath] }
            set { control[keyPath: keyPath] = newValue }
        }

        public subscript<T>(dynamicMember keyPath: WritableKeyPath<Api.State, T>) -> T {
            get { api[keyPath: keyPath] }
            set { api[keyPath: keyPath] = newValue }
        }
    }

    static let previewState = ControlFeatureState(
        control: Control.initialState,
        api: Api.previewState
    )
}
