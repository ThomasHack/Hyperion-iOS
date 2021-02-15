//
//  ClearData.swift
//  HyperionApi
//
//  Created by Hack, Thomas on 15.02.21.
//  Copyright © 2021 Hack, Thomas. All rights reserved.
//

import Foundation

public struct ClearData: Equatable, Codable {
    public let priority: Int

    public init(priority: Int) {
        self.priority = priority
    }
}
