//
//  Bullet.swift
//  CyBus
//
//  Created by Vadim Popov on 03/09/2025.
//

import SwiftUI

struct Bullet: View {
    let text: String
    let color: Color
    let emoji: String

    var body: some View {
        HStack(spacing: 10) {
            Text(emoji).font(.system(size: 18))
            Text(text)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(color)
        }
    }
}
