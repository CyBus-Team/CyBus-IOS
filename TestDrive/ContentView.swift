//
//  ContentView.swift
//  TestDrive
//
//  Created by Vadim Popov on 10/12/2025.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        Group {
            if let vehicle = appState.currentVehicle {
                VehicleDetailsView(vehicle: vehicle)
                    .onDisappear {
                        appState.currentVehicle = nil
                    }
            } else {
                VStack(spacing: 20) {
                    Image(systemName: "car.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.blue)
                    
                    Text("Test Drive")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Open a vehicle link to view details")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                        .padding()
                }
                .padding()
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AppState())
}
