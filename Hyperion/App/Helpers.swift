//
//  Helpers.swift
//  Hyperion
//
//  Created by Hack, Thomas on 17.08.20.
//  Copyright © 2020 Hack, Thomas. All rights reserved.
//

import UIKit

func distance(_ a: CGPoint, _ b: CGPoint) -> CGFloat {
    let distanceX = a.x - b.x
    let distanceY = a.y - b.y
    return CGFloat(sqrt(distanceX * distanceX + distanceY * distanceY))
}

extension CGFloat {
    func map(from: ClosedRange<CGFloat>, to: ClosedRange<CGFloat>) -> CGFloat {
        let result = ((self - from.lowerBound) / (from.upperBound - from.lowerBound)) * (to.upperBound - to.lowerBound) + to.lowerBound
        return result
    }
}
