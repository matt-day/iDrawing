//
//  ArtboardView.swift
//  iDrawing
//
//  Created by Matt Day on 3/23/22.
//

import SwiftUI

struct ArtboardView: View {
    @ObservedObject var manager = ArtboardManager()
    @State var colorSelected : Color = .blue
    @State var thickness : Double = 2.0
    
    var body: some View {
        
        let dragGesture = DragGesture(minimumDistance: 0.00000)
            .onChanged({ value in
                switch manager.currType {
                case .line:
                    if manager.inProgressShape == nil {
                        manager.inProgressShape = Line(points: [], color: manager.colorSelected, lineWidth: manager.thickness)
                        manager.deletedShapes.removeAll()
                    } else {
                        var _shape = manager.inProgressShape as! Line
                        _shape.points.append(value.location)
                        manager.inProgressShape = _shape
                    }
                case .rectangle, .ellipse:
                    if manager.inProgressShape == nil {
                        manager.newRec(at: value.location)
                        manager.deletedShapes.removeAll()
                    } else {
                        let _shape = manager.updateRec(to: value.location)
                        manager.inProgressShape = _shape
                    }
                }
            })
            .onEnded { value in
                manager.addShape()
            }
        
        
        return VStack {
            ZStack {
                Color.white
                Canvas { context, size in
                    
                    for _shape in manager.drawnShapes {
                        switch _shape.type {
                        case .line:
                            let _line = _shape as! Line
                            var path = Path()
                            path.addLines(_line.points)
                            context.stroke(path, with: .color(_line.color), lineWidth: _line.lineWidth)
                            
                        case .rectangle:
                            let _rec = _shape as! Rectangle
                            let _height = abs(_rec.origin.y - _rec.ending.y)
                            let _width = abs(_rec.origin.x - _rec.ending.x)
                            let _origX = (_rec.origin.x < _rec.ending.x ? _rec.origin.x: _rec.ending.x)
                            let _origY = (_rec.origin.y < _rec.ending.y ? _rec.origin.y: _rec.ending.y)
                            if (_rec.useForEllipse) {
                                context.fill(
                                    Path(ellipseIn: CGRect(origin: CGPoint(x: _origX, y: _origY), size: CGSize(width: _width, height: _height))), with: .color(_rec.color))
                            } else {
                                context.fill(
                                    Path(CGRect(origin: CGPoint(x: _origX, y: _origY), size: CGSize(width: _width, height: _height))), with: .color(_rec.color))
                            }
                        default:
                            break
                        }
                    }
                    
                    if manager.inProgressShape != nil {
                        switch manager.inProgressShape!.type {
                        case .line:
                            let _line = manager.inProgressShape as! Line
                            var path = Path()
                            path.addLines(_line.points)
                            context.stroke(path, with: .color(_line.color), lineWidth: _line.lineWidth)
                            
                        case .rectangle:
                            var _rec = manager.inProgressShape as! Rectangle
                            _rec.standardized()
                            if (_rec.useForEllipse) {
                                context.fill(
                                    Path(ellipseIn: CGRect(origin: CGPoint(x: _rec.origin.x, y: _rec.origin.y) , size: CGSize(width: _rec.width, height: _rec.height) ) ),
                                            with: .color(_rec.color))
                            } else {
                                context.fill(
                                    Path(CGRect(origin: CGPoint(x: _rec.origin.x, y: _rec.origin.y), size: CGSize(width: _rec.width, height: _rec.height) )
                                        ), with: .color(_rec.color))
                            }
                        default:
                            break
                        }
                    }
                }
                .gesture(dragGesture)
            }
            Spacer()
            BottomToolbarView()
                .environmentObject(manager)
        }
    }
}

struct ArtboardView_Previews: PreviewProvider {
    static var previews: some View {
        ArtboardView()
    }
}
