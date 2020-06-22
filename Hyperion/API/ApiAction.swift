//
//  ApiAction.swift
//  Hyperion
//
//  Created by Hack, Thomas on 14.06.20.
//  Copyright © 2020 Hack, Thomas. All rights reserved.
//

import Foundation

// MARK: - ApiAction

enum ApiAction: Equatable {
    case alertDismissed
    case connectButtonTapped
    case messageToSendChanged(String)
    case pingResponse(NSError?)
    case receivedSocketMessage(Result<ApiClient.Message, NSError>)
    case sendButtonTapped
    case sendResponse(NSError?)
    case webSocket(ApiClient.Action)
}
