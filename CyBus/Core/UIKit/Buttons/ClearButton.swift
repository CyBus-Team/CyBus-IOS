//
//  ClearButton.swift
//  CyBus
//
//  Created by Vadim Popov on 30/12/2024.
//

import SwiftUI

struct ClearButton: View {
    @Environment(\.theme) var theme
    
    @Binding var text: String
    
    var body: some View {
        if text.isEmpty == false {
            HStack {
                Spacer()
                Button {
                    text = ""
                } label: {
                    Image(systemName: "multiply.circle.fill")
                        .foregroundColor(Color(red: 0.7, green: 0.7, blue: 0.7))
                }
                .foregroundColor(.secondary)
            }
        } else {
            EmptyView()
        }
    }
}
