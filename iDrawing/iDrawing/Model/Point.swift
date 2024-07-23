//
//  Point.swift
//  iDrawing
//
//  Created by Matt Day on 3/24/22.
//

import Foundation

struct Point {
    var x : Double
    var y : Double
    static let zero = Point(x: 0, y:0)
    
    static func < (lhs:Point, rhs:Point) -> Bool {
        lhs.x < rhs.x && lhs.y < rhs.y
    }
    
    mutating func offsetBy(width:Double, height:Double) {
        self.x += width
        self.y += height
    }
}
