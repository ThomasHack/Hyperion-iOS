//
//  MockSession.swift
//  canda
//
//  Created by Tielmann, Andreas (DE - Duesseldorf) on 07.12.2018.
//  Copyright © 2018 Tielmann, Andreas (DE - Duesseldorf). All rights reserved.
//

import Foundation

/**
 * The MockSession looks for bundled json-files whose paths match the url, starting
 * from the *startSegment* (default: "api"). Example:
 * "https://example.com/api/users/hans/status" looks for the bundled file
 * "users_hans_status.json".
 * If you use a post-request with a non-empty body, this body is written to disk
 * and used for the next macthing get-request.
 * The mock-data directory is specific for the version number and build number.
 */
public struct MockSession: Session {

    public enum MockSessionError: Error {
        case noMockFound(String)
    }

    private let delay: TimeInterval
    private let startSegment: String
    private let bundlePrefix: String

    public init(delay: TimeInterval, startSegment: String = "api", bundlePrefix: String = "") {
        self.delay = delay
        self.startSegment = startSegment
        self.bundlePrefix = bundlePrefix
    }

    public func perform(_ request: URLRequest, completionHandler: @escaping (Data?, Int?, Error?) -> Void) {
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + delay) {
            do {
                try completionHandler(self.perform(request: request), nil, nil)
            } catch {
                completionHandler(nil, nil, error)
            }
        }
    }

    // MARK: - Private

    private func perform(request: URLRequest) throws -> Data {
        let components = request.url?.pathComponents ?? []
        let suffix = request.url?.query.map { "?" + $0 } ?? ""
        let path = self.path(from: components, suffix: suffix)
        if request.httpMethod == "POST", let body = request.httpBody {
            try write(data: body, to: path)
            return body
        } else {
            return try data(from: path)
        }
    }

    private func path(from components: [String], suffix: String) -> String {
        let startIndex = components.firstIndex(where: { $0 == startSegment }) ?? 0
        return bundlePrefix + components.suffix(from: startIndex + 1).joined(separator: "_") + suffix
    }

    private func write(data: Data, to path: String) throws {
        let cacheURL = try self.cacheURL(from: path)
        try data.write(to: cacheURL)
    }

    private func data(from path: String) throws -> Data {
        let cacheURL = try self.cacheURL(from: path)
        if FileManager.default.fileExists(atPath: cacheURL.path) {
            return try Data(contentsOf: cacheURL)
        } else {
            let url = try bundleURL(from: path)
            return try Data(contentsOf: url)
        }
    }

    private func cacheURL(from path: String) throws -> URL {
        let url = Self.cacheBaseURL.appendingPathComponent("\(path).json")
        let folderURL = url.deletingLastPathComponent()
        if !FileManager.default.fileExists(atPath: folderURL.path) {
            try FileManager.default.createDirectory(
                at: folderURL,
                withIntermediateDirectories: true,
                attributes: nil
            )
        }
        return url
    }

    private func bundleURL(from path: String) throws -> URL {
        guard let url = Bundle.main.url(forResource: path, withExtension: "json") else {
            throw MockSessionError.noMockFound(path)
        }
        return url
    }

    private static var cacheBaseURL: URL = {
        guard
            let documentsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first,
            let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String,
            let build = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String else {
                fatalError()
        }
        let url = documentsDir
            .appendingPathComponent(version)
            .appendingPathComponent(build)
        #if DEBUG
            print("Using Mock-Directory: \(url)")
        #endif
        return url
    }()
}
