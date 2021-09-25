//
//  SubscribeType.swift
//  HyperionApi
//
//  Created by Hack, Thomas on 15.02.21.
//  Copyright © 2021 Hack, Thomas. All rights reserved.
//

import Foundation

public enum SubscribeType: String, Codable {
    case adjustmentUpdate = "adjustment-update"
    case instanceUpdate = "instance-update"
    case componentUpdate = "components-update"
    case priorityUpdate = "priorities-update"
    case videoModeHdrUpdate = "videomodehdr-update"
}
