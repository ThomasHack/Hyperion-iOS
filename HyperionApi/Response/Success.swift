//
//  Success.swift
//  HyperionApi
//
//  Created by Hack, Thomas on 15.02.21.
//  Copyright © 2021 Hack, Thomas. All rights reserved.
//

import Foundation

public struct Success: Decodable {
    public let success: Bool

    public init(success: Bool) {
        self.success = success
    }
}
