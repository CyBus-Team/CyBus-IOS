//
//  Typography.swift
//  CyBus
//
//  Created by Vadim Popov on 13/10/2024.
//

import SwiftUICore

struct Typography {
    let largeTitle: Font
    let title: Font
    let largeTitleLogo: Font
    let titleLogo: Font
    let regular: Font
}

extension Typography {
    static let primary = Typography(
        largeTitle: .system(size: .init(34), weight: .bold, design: .default),
        title: .system(size: .init(20), weight: .semibold, design: .default),
        largeTitleLogo: .custom("Madimi One", size: 47),
        titleLogo: .custom("Madimi One", size: 36),
        regular: .system(size: .init(14), weight: .regular, design: .default)
    )
}
