//
//  CG+Convenience.swift
//  iDrawing
//
//  Created by Matt Day on 3/24/22.
//

import Foundation
import CoreGraphics

extension CGPoint {
    var point : Point {Point(x: self.x, y: self.y)}
    init(p:Point) {
        self.init()
        self.x = p.x
        self.y = p.y
    }
}
