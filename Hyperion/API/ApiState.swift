//
//  ApiState.swift
//  Hyperion
//
//  Created by Hack, Thomas on 14.06.20.
//  Copyright © 2020 Hack, Thomas. All rights reserved.
//

import ComposableArchitecture

// MARK: - ApiState

struct ApiState: Equatable {
    var alert: String?
    var connectivityState = ConnectivityState.disconnected
    var messageToSend = ""
    var receivedMessages: [String] = []
    var instances: [Instance] = []
    var hostname: String = ""
    var brightness: Int = 0

    enum ConnectivityState: String {
        case connected
        case connecting
        case disconnected
    }
}
