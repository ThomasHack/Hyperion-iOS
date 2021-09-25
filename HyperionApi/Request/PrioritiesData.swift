//
//  PrioritiesData.swift
//  HyperionApi
//
//  Created by Hack, Thomas on 15.02.21.
//  Copyright © 2021 Hack, Thomas. All rights reserved.
//

import Foundation

public struct PrioritiesData: Equatable, Decodable {
    public let priorities: [Priority]
    public let priorities_autoselect: Bool

    public init(priorities: [Priority], priorities_autoselect: Bool) {
        self.priorities = priorities
        self.priorities_autoselect = priorities_autoselect
    }
}
