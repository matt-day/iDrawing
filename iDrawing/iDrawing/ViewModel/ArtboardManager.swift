//
//  ArtboardManager.swift
//  iDrawing
//
//  Created by Matt Day on 3/23/22.
//

import Foundation
import SwiftUI

class ArtboardManager : ObservableObject {
    @Published var drawnShapes : [Shape] = [Shape]()
    @Published var inProgressShape : Shape?
    @Published var deletedShapes : [Shape] = [Shape]()
    
    @Published var colorSelected: Color = .blue
    @Published var thickness: Double = 1.0
    @Published var currType: ShapeType = .line
    
    func addShape(){
        if inProgressShape != nil{
            drawnShapes.append(inProgressShape!)
            inProgressShape = nil
        }
    }
    
    func newRec(at point: CGPoint){
        switch currType {
        case .rectangle:
            inProgressShape = Rectangle(color: colorSelected, origin: point.point, width: 0.0, height: 0.0)
        case .ellipse:
            inProgressShape = Rectangle(color: colorSelected, origin: point.point, width: 0.0, height: 0.0, useForEllipse: true)
        default:
            break
        }
        
    }
    
    func updateRec(to point: CGPoint) -> Rectangle{
        var _shape = inProgressShape as! Rectangle
        _shape.ending = point.point
        return _shape
    }
    
    func undo(){
        let lastShape = drawnShapes.popLast()
        deletedShapes.append(lastShape!)
    }
    
    func redo() {
        let lastDeleted = deletedShapes.popLast()
        drawnShapes.append(lastDeleted!)
    }
    
}
