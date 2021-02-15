//
//  ResponseServerInfo.swift
//  HyperionApi
//
//  Created by Hack, Thomas on 15.02.21.
//  Copyright © 2021 Hack, Thomas. All rights reserved.
//

import Foundation

public struct ServerInfoUpdate: Decodable {
    public let info: InfoData

    public init(info: InfoData) {
        self.info = info
    }
}
