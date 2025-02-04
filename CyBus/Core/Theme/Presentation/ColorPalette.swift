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
        primary: .init(red: 39/max, green: 113/max, blue: max/max), // Blue
        background: .white, // White
        foreground: .init(red: 213/max, green: 240/max, blue: 252/max), // Light blue
        secondary: .init(red: 33/max, green: 59/max, blue: 155/max), // Dark Blue
        linkTitle: .init(red: 120/max, green: 119/max, blue: 120/max), // Grey
        textFieldBackground: .init(red: 244/max, green: 244/max, blue: 244/max), // Light Grey
        destinationColor: .red,
        nodeColor: .green
    )
    
    static let dark = ColorPalette(
        primary: .init(red: 39/max, green: 113/max, blue: 255/max), // Blue
        background: .black, // Black
        foreground: .init(red: 213/max, green: 240/max, blue: 252/max), // Light blue
        secondary: .init(red: 33/max, green: 59/max, blue: 155/max), // Dark Blue
        linkTitle: .init(red: 120/max, green: 119/max, blue: 120/max), // Grey
        textFieldBackground: .init(red: 244/max, green: 244/max, blue: 244/max), // Light Grey
        destinationColor: .red,
        nodeColor: .green
    )
}

extension Color {
    init(fromHex: String) {
        let hex = Array(fromHex.dropFirst(1))
        let red = Double(Int(String(hex[0..<2]), radix: 16) ?? 0)
        let green = Double(Int(String(hex[2..<4]), radix: 16) ?? 0)
        let blue = Double(Int(String(hex[4..<6]), radix: 16) ?? 0)
        self.init(red: red/255, green: green/255, blue: blue/255)
    }
    func toHex(_ color: Int) -> String {
        let value: Double = Double(color) / 16.0
        let integer = value.rounded(.towardZero)
        let fractional = (value - integer) * 16
        return "\(integer.hex)\(fractional.hex)"
    }
}

extension Double {
    var hex: String {
        [0: "0", 1: "1", 2: "2", 3: "3", 4: "4",5: "5",6: "6",7: "7",8: "8",9: "9",10: "A",11: "B",12: "C",13: "D",14: "E",15: "F"][self] ?? ""
    }
}

