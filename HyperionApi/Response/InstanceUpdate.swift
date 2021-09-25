//
//  ResponseInstanceUpdate.swift
//  HyperionApi
//
//  Created by Hack, Thomas on 15.02.21.
//  Copyright © 2021 Hack, Thomas. All rights reserved.
//

import Foundation

//TODO: ENUM implementation
public struct InstanceUpdate: Decodable {
    public let data: [Instance]

    public init(data: [Instance]) {
        self.data = data
    }
}
