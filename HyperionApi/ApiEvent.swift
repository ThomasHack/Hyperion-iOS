//
//  ApiEvent.swift
//  HyperionApi
//
//  Created by Hack, Thomas on 15.02.21.
//  Copyright © 2021 Hack, Thomas. All rights reserved.
//

import Foundation

public enum ApiEvent: Equatable {
    case connected              // case connected([String: String])
    case disconnected           // case disconnected(String, UInt16)
    case text(String)           // case text(String)
    case binary(Data)           // case binary(Data)
    case ping                   // case ping(Data?)
    case pong                   // case pong(Data?)
    // case viabilityChanged    // case viabilityChanged(Bool)
    // reconnectSuggested       // case reconnectSuggested(Bool)
    case cancelled              // case cancelled
    case error(NSError?)        // case error(Error?)
}
