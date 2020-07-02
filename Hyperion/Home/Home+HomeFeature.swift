//
//  Home+HomeFeature.swift
//  Hyperion
//
//  Created by Hack, Thomas on 01.07.20.
//  Copyright © 2020 Hack, Thomas. All rights reserved.
//

import ComposableArchitecture
import Foundation

extension Home {
    @dynamicMemberLookup
    struct HomeFeatureState: Equatable {
        var home: Home.State
        var shared: Shared.State
        var api: Api.State

        public subscript<T>(dynamicMember keyPath: WritableKeyPath<Home.State, T>) -> T {
            get { home[keyPath: keyPath] }
            set { home[keyPath: keyPath] = newValue }
        }

        public subscript<T>(dynamicMember keyPath: WritableKeyPath<Shared.State, T>) -> T {
            get { shared[keyPath: keyPath] }
            set { shared[keyPath: keyPath] = newValue }
        }

        public subscript<T>(dynamicMember keyPath: WritableKeyPath<Api.State, T>) -> T {
            get { api[keyPath: keyPath] }
            set { api[keyPath: keyPath] = newValue }
        }
    }

    static let previewState = HomeFeatureState(
        home: Home.State(),
        shared: Shared.State(
            host: "http://preview.host",
            showSettingsModal: false
        ),
        api: Api.previewState
    )
}
