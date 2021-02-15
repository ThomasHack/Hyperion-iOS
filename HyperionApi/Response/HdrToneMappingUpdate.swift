//
//  ResponseHdrToneMappingUpdate.swift
//  HyperionApi
//
//  Created by Hack, Thomas on 15.02.21.
//  Copyright © 2021 Hack, Thomas. All rights reserved.
//

import Foundation

//TODO: ENUM implementation
public struct HdrToneMappingUpdate: Decodable {
    public let data: HdrToneMapping

    public init(data: HdrToneMapping) {
        self.data = data
    }
}
