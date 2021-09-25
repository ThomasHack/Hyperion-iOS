//
//  HdrToneMappingData.swift
//  HyperionApi
//
//  Created by Hack, Thomas on 15.02.21.
//  Copyright © 2021 Hack, Thomas. All rights reserved.
//

import Foundation

public struct HdrToneMapping: Equatable, Decodable {
    public let videomodehdr: Int

    public init(videomodehdr: Int) {
        self.videomodehdr = videomodehdr
    }
}
