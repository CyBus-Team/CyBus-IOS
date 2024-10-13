//
//  ColorPalette.swift
//  CyBus
//
//  Created by Vadim Popov on 13/10/2024.
//

import SwiftUI

struct ColorPalette {
    let primary: Color
    let background: Color
    let foreground: Color
    let secondary: Color
}

extension ColorPalette {
    static let light = ColorPalette(
        primary: .init(red: 39/255, green: 113/255, blue: 255/255), // Blue
        background: Color.white, // White
        foreground: .init(red: 213/255, green: 240/255, blue: 252/255), // Light blue
        secondary: .init(red: 33/255, green: 59/255, blue: 155/255) // Dark Blue
    )
    
    static let dark = ColorPalette(
        primary: .init(red: 39/255, green: 113/255, blue: 255/255), // Blue
        background: Color.black,
        foreground: .init(red: 213/255, green: 240/255, blue: 252/255), // Light blue
        secondary: .init(red: 33/255, green: 59/255, blue: 155/255) // Dark Blue
    )
}
