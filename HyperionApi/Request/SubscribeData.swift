//
//  SubscribeData.swift
//  HyperionApi
//
//  Created by Hack, Thomas on 15.02.21.
//  Copyright © 2021 Hack, Thomas. All rights reserved.
//

import Foundation

public struct SubscribeData: Equatable, Codable {
    public let subscribe: [SubscribeType]

    public init(subscribe: [SubscribeType]) {
        self.subscribe = subscribe
    }
}
