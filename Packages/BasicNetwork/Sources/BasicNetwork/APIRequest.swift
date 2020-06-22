//
//  APIRequest.swift
//  canda
//
//  Created by Tielmann, Andreas (DE - Duesseldorf) on 06.12.2018.
//  Copyright © 2018 Tielmann, Andreas (DE - Duesseldorf). All rights reserved.
//

import Foundation

public struct EmptyBody: Encodable {
    public init() {}
}

public struct EmptyResult: Decodable {
    public init() {}
}

public enum Method: String {
    case get, post, delete, patch
}

public enum NetworkError: Error {
    case rawError(Error)
    case noData(URL)
    case urlError(String)
    case invalidStatusCode(Int, url: URL, method: Method, text: String?)
}

open class APIRequest<BodyType: Encodable, ResultType: Decodable> {
    public let url: URL
    public let headers: [String: String?]
    public let method: Method
    public let body: BodyType?
    public let bodyDateFormatter: DateFormatter
    public let responseDateFormatter: DateFormatter
    public let acceptableStatusCodes: Range<Int>

    public init(url: URL, headers: [String: String?] = [:], method: Method = .get, body: BodyType? = nil, bodyDateFormatter: DateFormatter = .iso8601Full, responseDateFormatter: DateFormatter = .iso8601Full, acceptableStatusCodes: Range<Int> = 100..<300) {
        self.url = url
        self.headers = headers
        self.method = method
        self.body = body
        self.bodyDateFormatter = bodyDateFormatter
        self.responseDateFormatter = responseDateFormatter
        self.acceptableStatusCodes = acceptableStatusCodes
    }

    public func start(with session: Session, completion: @escaping (Result<ResultType, Error>) -> Void) {
        perform(with: session) { data, statusCode, error in
            let result = self.process(data: data, statusCode: statusCode, error: error)
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }

    private func process(data: Data?, statusCode: Int?, error: Error?) -> Result<ResultType, Error> {
        if let statusCode = statusCode, !self.acceptableStatusCodes.contains(statusCode) {
            let error = NetworkError.invalidStatusCode(
                statusCode,
                url: url,
                method: method,
                text: data.flatMap { String(data: $0, encoding: .utf8) }
            )
            return .failure(error)
        }

        if let emptyResult = EmptyResult() as? ResultType {
            return .success(emptyResult)
        }

        guard let data = data else {
            if let error = error {
                return .failure(NetworkError.rawError(error))
            } else {
                return .failure(NetworkError.noData(self.url))
            }
        }

        do {
            return try .success(self.decode(result: data))
        } catch let error {
            return .failure(error)
        }
    }

    public func perform(with session: Session, completion: @escaping (Data?, Int?, Error?) -> Void) {
        var request = URLRequest(url: url)
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        request.httpMethod = method.rawValue.uppercased()

        if let body = body {
            do {
                request.httpBody = try encode(body: body, for: &request)
            } catch let error {
                completion(nil, nil, error)
                return
            }
        }

        session.perform(request, completionHandler: completion)
    }

    open func decode(result: Data) throws -> ResultType {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(self.responseDateFormatter)
        return try decoder.decode(ResultType.self, from: result)
    }

    open func encode(body: BodyType, for request: inout URLRequest) throws -> Data {
        if request.value(forHTTPHeaderField: "Content-Type") == nil {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(self.bodyDateFormatter)
        return try encoder.encode(body)
    }
}
