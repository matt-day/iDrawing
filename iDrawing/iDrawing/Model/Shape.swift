//
//  Shape.swift
//  iDrawing
//
//  Created by Matt Day on 3/23/22.
//

import Foundation
import SwiftUI

enum ShapeType : String, CaseIterable {
    var id: String { self.rawValue }
    case line = "line"
    case rectangle = "rectangle"
    case ellipse = "ellipse"
}

protocol Shape {
    var type : ShapeType {get set}
}

struct Line : Shape {
    var type = ShapeType.line
    var points = [CGPoint]()
    var color = Color.red
    var lineWidth : Double = 1.0
}

struct Rectangle : Shape {
    var type = ShapeType.rectangle
    var color = Color.red
    
    var origin : Point
    var width : Double
    var height : Double
    var zIndex : Double = 0
    var useForEllipse: Bool = false
}

extension Rectangle {
    var center : Point {
        get {
            return Point(x: origin.x + width / 2, y: origin.y + height / 2)
        }
        set(newValue){
            origin = Point(x: newValue.x - width / 2, y: newValue.y - height / 2)
        }
    }
    
    var ending : Point {
        get {
            return Point(x: origin.x + width, y: origin.y + height)
        }
        set(newValue){
            width = newValue.x - origin.x
            height = newValue.y - origin.y
        }
    }
    
    mutating func standardized() {
        if width < 0 {
            origin = Point(x: ending.x, y: origin.y)
            width = -width
        }
        if height < 0 {
            origin = Point(x: origin.x, y: ending.y)
            height = -height
        }
    }
}
