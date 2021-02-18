//
//  App+AppFeature.swift
//  Hyperion
//
//  Created by Hack, Thomas on 18.02.21.
//  Copyright © 2021 Hack, Thomas. All rights reserved.
//

import Foundation

extension App {
    @dynamicMemberLookup
    struct AppFeatureState: Equatable {
        var app: App.State
        var api: Api.State

        public subscript<T>(dynamicMember keyPath: WritableKeyPath<App.State, T>) -> T {
            get { app[keyPath: keyPath] }
            set { app[keyPath: keyPath] = newValue }
        }

        public subscript<T>(dynamicMember keyPath: WritableKeyPath<Api.State, T>) -> T {
            get { api[keyPath: keyPath] }
            set { api[keyPath: keyPath] = newValue }
        }
    }

    static let previewState = AppFeatureState(
        app: App.State(),
        api: Api.previewState
    )
}
