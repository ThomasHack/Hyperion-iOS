//
//  Request.swift
//  HyperionApi
//
//  Created by Hack, Thomas on 15.02.21.
//  Copyright © 2021 Hack, Thomas. All rights reserved.
//

import Foundation

public struct Request: Equatable, Codable {
    public let command: RequestType

    public init(command: RequestType) {
        self.command = command
    }
}

public typealias InstanceRequest = Compose<Request, InstanceData>
public typealias SubscribeRequest = Compose<Request, SubscribeData>
public typealias AdjustmentRequest = Compose<Request, AdjustmentData>
public typealias ComponentRequest = Compose<Request, ComponentData>
public typealias ColorRequest = Compose<Request, ColorData>
public typealias EffectRequest = Compose<Request, EffectData>
public typealias ClearRequest = Compose<Request, ClearData>
public typealias HdrToneMappingRequest = Compose<Request, HdrToneMappingData>
