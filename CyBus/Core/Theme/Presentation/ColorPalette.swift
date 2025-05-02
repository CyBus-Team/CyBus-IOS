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
        primary: .blue,
        background: .white,
        foreground: Color(.systemTeal),
        secondary: Color(.systemBlue),
        linkTitle: .gray,
        textFieldBackground: Color(.systemGray6),
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
