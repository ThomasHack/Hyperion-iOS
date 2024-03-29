//
//  ApiClient.swift
//  Hyperion
//
//  Created by Hack, Thomas on 16.02.21.
//  Copyright © 2021 Hack, Thomas. All rights reserved.
//  swiftlint:disable convenience_type

import Foundation
import HyperionApi

enum ApiClientError: Error, Equatable {
    case hostKeyMissing
    case invalidUrl
}

struct ApiClient {
    static let appGroupName = "group.hyperion-ng"
    static let hostDefaultsKeyName = "hyperion.hostname"
    static let iconsDefaultsKeyName = "hyperion.instanceIcons"

    static let userDefaults = UserDefaults(suiteName: appGroupName)

    static func fetchServerInfo(completion: @escaping (Result<HyperionApi.ServerInfoUpdate, Error>) -> Void) {

        guard let host = userDefaults?.string(forKey: hostDefaultsKeyName) else {
            return completion(.failure(ApiClientError.hostKeyMissing))
        }

        guard let url = URL(string: "\(host)/json-rpc") else {
            return completion(.failure(ApiClientError.invalidUrl))
        }

        do {
            let message = ApiInfoRequest(command: "serverinfo")
            let data = try JSONEncoder().encode(message)

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = data

            URLSession.shared.dataTask(with: request) { data, _, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                if let data = data {
                    do {
                        let response = try JSONDecoder().decode(HyperionApi.ServerInfoUpdate.self, from: data)
                        DispatchQueue.main.async {
                            completion(.success(response))
                        }
                    } catch {
                        completion(.failure(error))
                        print("error: \(error.localizedDescription)")
                    }
                }
            }
            .resume()
        } catch {
            assertionFailure("")
        }
    }

    static let previewData = HyperionApi.InfoData(adjustments: [],
                                                  instances: [
                                                    HyperionApi.Instance(instance: 0, running: true, friendlyName: "LG OLED Ambilight"),
                                                    HyperionApi.Instance(instance: 1, running: false, friendlyName: "Hue Sync"),
                                                    HyperionApi.Instance(instance: 2, running: false, friendlyName: "Hue Play Lightbars")
                                                  ],
                                                  hostname: "HyperHDR",
                                                  effects: [],
                                                  components: [
                                                      HyperionApi.Component(name: .all, enabled: true),
                                                      HyperionApi.Component(name: .smoothing, enabled: true),
                                                      HyperionApi.Component(name: .blackborder, enabled: false),
                                                      HyperionApi.Component(name: .v4l, enabled: false),
                                                      HyperionApi.Component(name: .led, enabled: true)
                                                  ],
                                                  priorities: [],
                                                  hdrToneMapping: 0
    )

    static let placeholderData = HyperionApi.InfoData(adjustments: [],
                                                      instances: [],
                                                      hostname: "",
                                                      effects: [],
                                                      components: [],
                                                      priorities: [],
                                                      hdrToneMapping: 0
    )
}
