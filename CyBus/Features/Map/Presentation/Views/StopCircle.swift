//
//  StopCircle.swift
//  CyBus
//
//  Created by Vadim Popov on 04/09/2024.
//

import SwiftUI

struct StopCircle : View {
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.blue)
                .frame(width: 20, height: 20)
            Circle()
                .fill(Color.white)
                .frame(width: 10, height: 10)
                .blendMode(.destinationOut)
        }
    }
}
