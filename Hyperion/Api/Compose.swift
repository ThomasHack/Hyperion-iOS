//
//  Compose.swift
//  Hyperion
//
//  Created by Hack, Thomas on 26.06.20.
//  Copyright © 2020 Hack, Thomas. All rights reserved.
//

import Foundation

@dynamicMemberLookup
public struct Compose<Element1, Element2> {
    /// The first element of the composition. In most cases you should not use this property, and
    /// instead, in order to access the child properties you better use the dynamicMember subscript
    public var _element1: Element1
    /// The second element of the composition. In most cases you should not use this property, and
    /// instead, in order to access the child properties you better use the dynamicMember subscript
    public var _element2: Element2

    public subscript<T>(dynamicMember keyPath: WritableKeyPath<Element1, T>) -> T {
        get { _element1[keyPath: keyPath] }
        set { _element1[keyPath: keyPath] = newValue }
    }

    public subscript<T>(dynamicMember keyPath: WritableKeyPath<Element2, T>) -> T {
        get { _element2[keyPath: keyPath] }
        set { _element2[keyPath: keyPath] = newValue }
    }

    public subscript<T>(dynamicMember keyPath: KeyPath<Element1, T>) -> T {
        _element1[keyPath: keyPath]
    }

    public subscript<T>(dynamicMember keyPath: KeyPath<Element2, T>) -> T {
        _element2[keyPath: keyPath]
    }

    public init(_ _element1: Element1, _ _element2: Element2) {
        self._element1 = _element1
        self._element2 = _element2
    }
}

extension Compose: Encodable where Element1: Encodable, Element2: Encodable {
    public func encode(to encoder: Encoder) throws {
        // Here, if element1 has any property with the same name as element2, element1 property will prevail
        // because it will override the property from element2
        try _element1.encode(to: encoder)
        try _element2.encode(to: encoder)
    }
}

extension Compose: Decodable where Element1: Decodable, Element2: Decodable {
    public init(from decoder: Decoder) throws {
        self._element1 = try Element1(from: decoder)
        self._element2 = try Element2(from: decoder)
    }
}

extension Compose: Equatable where Element1: Equatable, Element2: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs._element1 == rhs._element1 &&
            lhs._element2 == rhs._element2
    }
}

@dynamicMemberLookup
public struct Compose3<Element1, Element2, Element3> {
    public var _element1: Element1
    public var _element2: Element2
    public var _element3: Element3

    public subscript<T>(dynamicMember keyPath: WritableKeyPath<Element1, T>) -> T {
        get { _element1[keyPath: keyPath] }
        set { _element1[keyPath: keyPath] = newValue }
    }

    public subscript<T>(dynamicMember keyPath: WritableKeyPath<Element2, T>) -> T {
        get { _element2[keyPath: keyPath] }
        set { _element2[keyPath: keyPath] = newValue }
    }

    public subscript<T>(dynamicMember keyPath: WritableKeyPath<Element3, T>) -> T {
        get { _element3[keyPath: keyPath] }
        set { _element3[keyPath: keyPath] = newValue }
    }

    public subscript<T>(dynamicMember keyPath: KeyPath<Element1, T>) -> T {
        _element1[keyPath: keyPath]
    }

    public subscript<T>(dynamicMember keyPath: KeyPath<Element2, T>) -> T {
        _element2[keyPath: keyPath]
    }

    public subscript<T>(dynamicMember keyPath: KeyPath<Element3, T>) -> T {
        _element3[keyPath: keyPath]
    }

    public init(_ _element1: Element1, _ _element2: Element2, _ _element3: Element3) {
        self._element1 = _element1
        self._element2 = _element2
        self._element3 = _element3
    }
}

extension Compose3: Encodable where Element1: Encodable, Element2: Encodable, Element3: Encodable {
    public func encode(to encoder: Encoder) throws {
        try _element1.encode(to: encoder)
        try _element2.encode(to: encoder)
        try _element3.encode(to: encoder)
    }
}

extension Compose3: Decodable where Element1: Decodable, Element2: Decodable, Element3: Decodable {
    public init(from decoder: Decoder) throws {
        self._element1 = try Element1(from: decoder)
        self._element2 = try Element2(from: decoder)
        self._element3 = try Element3(from: decoder)
    }
}

extension Compose3: Equatable where Element1: Equatable, Element2: Equatable, Element3: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs._element1 == rhs._element1
            && lhs._element2 == rhs._element2
            && lhs._element3 == rhs._element3
    }
}

/*

public typealias Compose3<T1, T2, T3> =
    Compose<T1, Compose<T2, T3>>

public typealias Compose4<T1, T2, T3, T4> =
    Compose<Compose<T1, T2>, Compose<T3, T4>>

public typealias Compose5<T1, T2, T3, T4, T5> =
    Compose<Compose<T1, T2>, Compose<T3, Compose<T4, T5>>>
*/
