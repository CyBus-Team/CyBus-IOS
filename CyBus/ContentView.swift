//
//  ContentView.swift
//  CyBus
//
//  Created by Vadim Popov on 24/06/2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Button("Run") {
                downloadAndParseBinaryFile(from: "http://20.19.98.194:8328/Api/api/gtfs-realtime")
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
