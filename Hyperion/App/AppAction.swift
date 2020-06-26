//
//  ApiAction.swift
//  Hyperion
//
//  Created by Hack, Thomas on 14.06.20.
//  Copyright © 2020 Hack, Thomas. All rights reserved.
//

import Foundation

// MARK: - AppAction

enum AppAction: Equatable {
    case connectButtonTapped
    case messageToSendChanged(String)
    case receivedMessage(Result<String, NSError>)
    case sendButtonTapped
}
