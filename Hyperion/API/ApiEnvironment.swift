//
//  ApiEnvironment.swift
//  Hyperion
//
//  Created by Hack, Thomas on 14.06.20.
//  Copyright © 2020 Hack, Thomas. All rights reserved.
//

import Foundation
import ComposableArchitecture

// MARK: - ApiEnvironment

struct ApiEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var webSocket: ApiClient
}
