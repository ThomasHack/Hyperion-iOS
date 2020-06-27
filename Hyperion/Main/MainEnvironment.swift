//
//  AppEnvironment.swift
//  Hyperion
//
//  Created by Hack, Thomas on 26.06.20.
//  Copyright © 2020 Hack, Thomas. All rights reserved.
//

import Foundation
import ComposableArchitecture
import Combine

struct MainEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var apiClient: ApiClient
}
