//
//  Session.swift
//  GK App
//
//  Created by Tielmann, Andreas (DE - Duesseldorf) on 02.04.2019.
//

import Foundation

public protocol Session {
    func perform(_ request: URLRequest, completionHandler: @escaping (Data?, Int?, Error?) -> Void)
}
