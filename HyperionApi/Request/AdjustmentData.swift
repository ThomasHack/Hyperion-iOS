//
//  AdjustmentData.swift
//  HyperionApi
//
//  Created by Hack, Thomas on 15.02.21.
//  Copyright © 2021 Hack, Thomas. All rights reserved.
//

import Foundation

public struct AdjustmentData: Equatable, Codable {
    public let adjustment: Adjustment

    public init(adjustment: Adjustment) {
        self.adjustment = adjustment
    }
}
