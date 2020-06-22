//
//  DateFormatter+iso8601.swift
//  Deloitte-Network
//
//  Created by Tielmann, Andreas (DE - Duesseldorf) on 03.04.2019.
//  Copyright © 2019 Deloitte Digital GmbH. All rights reserved.
//

import Foundation

// swiftlint:disable no_extension_access_modifier
public extension DateFormatter {
    static let iso8601Full: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()

    static let iso8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
}
