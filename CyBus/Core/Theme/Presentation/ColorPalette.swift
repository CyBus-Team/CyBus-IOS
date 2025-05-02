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
    let textFieldBackground: Color
    let destinationColor: Color
    let nodeColor: Color
}

fileprivate let max = 255.0

extension ColorPalette {
    static let light = ColorPalette(
        primary: .blue,                        // .init(red: 39, 113, 255)
        background: .white,
        foreground: Color(.systemTeal),        // .init(red: 213, 240, 252)
        secondary: Color(.systemBlue),         // .init(red: 33, 59, 155)
        linkTitle: .gray,                      // .init(red: 120, 119, 120)
        textFieldBackground: Color(.systemGray6), // .init(red: 244, 244, 244)
        destinationColor: .red,
        nodeColor: .green
    )

    static let dark = ColorPalette(
        primary: .blue,
        background: .black,
        foreground: Color(.systemTeal),
        secondary: Color(.systemBlue),
        linkTitle: .gray,
        textFieldBackground: Color(.systemGray5),
        destinationColor: .red,
        nodeColor: .green
    )
}
