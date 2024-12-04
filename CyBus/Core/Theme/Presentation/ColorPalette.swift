//
//  ColorPalette.swift
//  CyBus
//
//  Created by Vadim Popov on 13/10/2024.
//

import SwiftUI
import Foundation

struct ColorPalette {
    let primary: Color
    let background: Color
    let foreground: Color
    let secondary: Color
    let linkTitle: Color
}

extension ColorPalette {
    static let light = ColorPalette(
        primary: .init(red: 39/255, green: 113/255, blue: 255/255), // Blue
        background: Color.white, // White
        foreground: .init(red: 213/255, green: 240/255, blue: 252/255), // Light blue
        secondary: .init(red: 33/255, green: 59/255, blue: 155/255), // Dark Blue
        linkTitle: .init(red: 120/255, green: 119/255, blue: 120/255) // Grey
    )
    
    static let dark = ColorPalette(
        primary: .init(red: 39/255, green: 113/255, blue: 255/255), // Blue
        background: Color.black,
        foreground: .init(red: 213/255, green: 240/255, blue: 252/255), // Light blue
        secondary: .init(red: 33/255, green: 59/255, blue: 155/255), // Dark Blue
        linkTitle: .init(red: 120/255, green: 119/255, blue: 120/255) // Grey
    )
}

extension Color {
    init(hexStringToColor: String = "#2771ff") {
        
        let hex = Array(hexStringToColor.dropFirst(1))
        let red = Double(Int(String(hex[0..<2]), radix: 16) ?? 0)
        let green = Double(Int(String(hex[2..<4]), radix: 16) ?? 0)
        let blue = Double(Int(String(hex[4..<6]), radix: 16) ?? 0)
        self.init(red: red/255, green: green/255, blue: blue/255)
    }
}
