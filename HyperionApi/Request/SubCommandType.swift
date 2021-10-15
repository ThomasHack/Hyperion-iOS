//
//  SubCommandType.swift
//  HyperionApi
//
//  Created by Hack, Thomas on 15.02.21.
//  Copyright © 2021 Hack, Thomas. All rights reserved.
//

import Foundation

public enum SubCommandType: String, Codable {
    case startInstance
    case stopInstance
    case switchTo
}
