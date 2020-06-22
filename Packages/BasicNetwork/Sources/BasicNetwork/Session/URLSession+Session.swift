//
//  URLSession+Session.swift
//  canda
//
//  Created by Tielmann, Andreas (DE - Duesseldorf) on 13.12.2018.
//  Copyright © 2018 Tielmann, Andreas (DE - Duesseldorf). All rights reserved.
//

import Foundation

extension URLSession: Session {
    public func perform(_ request: URLRequest, completionHandler: @escaping (Data?, Int?, Error?) -> Void) {
        let task = dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                let httpResponse = response as? HTTPURLResponse
                completionHandler(data, httpResponse?.statusCode, error)
            }
        }
        task.resume()
    }
}
