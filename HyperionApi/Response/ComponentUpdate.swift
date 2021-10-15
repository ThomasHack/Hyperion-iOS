//
//  ResponseComponentUpdate.swift
//  HyperionApi
//
//  Created by Hack, Thomas on 15.02.21.
//  Copyright © 2021 Hack, Thomas. All rights reserved.
//

import Foundation

public struct ComponentUpdate: Decodable {
    public let data: Component

    public init(data: Component) {
        self.data = data
    }
}
