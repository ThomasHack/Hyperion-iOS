//
//  HdrToneMappingData.swift
//  HyperionApi
//
//  Created by Hack, Thomas on 15.02.21.
//  Copyright © 2021 Hack, Thomas. All rights reserved.
//

import Foundation

public struct HdrToneMappingData: Equatable, Codable {
    public let hdr: Int

    enum CodingKeys: String, CodingKey {
        case hdr = "HDR"
    }

    public init(hdr: Int) {
        self.hdr = hdr
    }
}
