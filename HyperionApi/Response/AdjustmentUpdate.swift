//
//  ResponseAdjustmentUpdate.swift
//  HyperionApi
//
//  Created by Hack, Thomas on 15.02.21.
//  Copyright © 2021 Hack, Thomas. All rights reserved.
//

import Foundation

//TODO: ENUM implementation
public struct AdjustmentUpdate: Decodable {
    public let data: [Adjustment]

    public init(data: [Adjustment]) {
        self.data = data
    }
}
