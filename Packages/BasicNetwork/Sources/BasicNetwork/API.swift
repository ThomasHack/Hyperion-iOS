//
//  API.swift
//  GK App
//
//  Created by Tielmann, Andreas (DE - Duesseldorf) on 02.04.2019.
//

import Foundation

public protocol API {
    var session: Session { get set }
    var baseURL: URL { get set }
    var bodyDateFormatter: DateFormatter { get set }
    var responseDateFormatter: DateFormatter { get set }
    var acceptableStatusCodes: Range<Int> { get set }
    var baseHeaders: [String: String?] { get set }
}
