//
//  ApiState.swift
//  Hyperion
//
//  Created by Hack, Thomas on 14.06.20.
//  Copyright © 2020 Hack, Thomas. All rights reserved.
//

import ComposableArchitecture

// MARK: - AppState

struct AppState: Equatable {
    var messageToSend = ""
    var receivedMessages: [String] = []
    // var instances: [Instance] = []
    // var hostname: String = ""
    // var brightness: Int = 0
}
