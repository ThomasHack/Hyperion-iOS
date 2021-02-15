//
//  ResponsePriorityUpdate.swift
//  HyperionApi
//
//  Created by Hack, Thomas on 15.02.21.
//  Copyright © 2021 Hack, Thomas. All rights reserved.
//

import Foundation

//TODO: ENUM implementation
public struct PriorityUpdate: Decodable {
    public let data: PrioritiesData

    public init(data: PrioritiesData) {
        self.data = data
    }
}
