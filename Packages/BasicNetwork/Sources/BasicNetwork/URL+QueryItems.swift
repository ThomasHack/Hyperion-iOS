//
//  URL+QueryItems.swift
//  Deloitte-Network
//
//  Created by Tielmann, Andreas (DE - Duesseldorf) on 03.04.2019.
//  Copyright © 2019 Deloitte Digital GmbH. All rights reserved.
//

import Foundation

// swiftlint:disable:next no_extension_access_modifier
public extension URL {

    func appending(queryItems: [URLQueryItem]) -> URL? {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        var items: [URLQueryItem] = components?.queryItems ?? []
        items += queryItems
        components?.queryItems = items
        return components?.url
    }

    func appending(queryItems: [(String, [String])]) -> URL? {
        let newItems = queryItems.reduce(into: [URLQueryItem]()) { result, entry in
            let items = entry.1.map { URLQueryItem(name: entry.0, value: $0) }
            result.append(contentsOf: items)
        }
        return self.appending(queryItems: newItems)
    }
}
