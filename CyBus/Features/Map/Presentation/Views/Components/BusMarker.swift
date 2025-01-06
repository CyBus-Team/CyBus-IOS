//
//  BusMarker.swift
//  CyBus
//
//  Created by Artem on 13.11.2024.
//
import Foundation
import SwiftUI

struct BusMarker: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0.5*width, y: 0))
        path.addCurve(to: CGPoint(x: 0.14865*width, y: 0.35135*height), control1: CGPoint(x: 0.33784*width, y: 0), control2: CGPoint(x: 0.14865*width, y: 0.0991*height))
        path.addCurve(to: CGPoint(x: 0.5*width, y: height), control1: CGPoint(x: 0.14865*width, y: 0.52252*height), control2: CGPoint(x: 0.41892*width, y: 0.9009*height))
        path.addCurve(to: CGPoint(x: 0.85135*width, y: 0.35135*height), control1: CGPoint(x: 0.57207*width, y: 0.9009*height), control2: CGPoint(x: 0.85135*width, y: 0.53153*height))
        path.addCurve(to: CGPoint(x: 0.5*width, y: 0), control1: CGPoint(x: 0.85135*width, y: 0.0991*height), control2: CGPoint(x: 0.66216*width, y: 0))
        path.closeSubpath()
        return path
    }
}
