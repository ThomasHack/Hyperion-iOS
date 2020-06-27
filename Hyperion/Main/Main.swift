//
//  Main.swift
//  Hyperion
//
//  Created by Hack, Thomas on 27.06.20.
//  Copyright © 2020 Hack, Thomas. All rights reserved.
//

import ComposableArchitecture
import Foundation

struct MainState: Equatable {

    enum ConnectivityState {
        case connected
        case connecting
        case disconnected
    }

    var connectivityState: ConnectivityState
    
}
