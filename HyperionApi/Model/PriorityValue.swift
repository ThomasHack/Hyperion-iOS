//
//  PriorityValue.swift
//  HyperionApi
//
//  Created by Hack, Thomas on 15.02.21.
//  Copyright © 2021 Hack, Thomas. All rights reserved.
//

import UIKit

public struct PriorityValue: Equatable, Decodable {
    public let hsl: [Float]
    public let rgb: [Float]
    public var color: UIColor? {
        guard rgb.count == 3 else { return nil }
        return UIColor(red: CGFloat(rgb[0] / 255), green: CGFloat(rgb[1] / 255), blue: CGFloat(rgb[2] / 255), alpha: 1.0)
    }

    enum CodingKeys: String, CodingKey {
        case hsl = "HSL"
        case rgb = "RGB"
    }

    public init(hsl: [Float], rgb: [Float], color: UIColor?) {
        self.hsl = hsl
        self.rgb = rgb
    }
}
