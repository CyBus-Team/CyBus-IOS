//
//  TestDriveApp.swift
//  TestDrive
//
//  Created by Vadim Popov on 10/12/2025.
//

import SwiftUI

@main
struct TestDriveApp: App {
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .onOpenURL { url in
                    handleIncomingURL(url)
                }
        }
    }
    
    @MainActor
    private func handleIncomingURL(_ url: URL) {
        // Handle URL from associated domain
        guard url.scheme == "https" || url.scheme == "http" else { return }
        
        // Extract data from URL
        if let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
           let queryItems = components.queryItems {
            
            var vehicleData: [String: Any] = [:]
            for item in queryItems {
                vehicleData[item.name] = item.value
            }
            
            // Try to create Vehicle from URL parameters
            if let vehicle = createVehicleFromURLParameters(vehicleData) {
                appState.currentVehicle = vehicle
            } else if let qrData = vehicleData["qr"] as? String {
                // If there's a qr parameter, parse it
                appState.currentVehicle = VehicleQRParser.parse(qrData)
            }
        } else {
            // If URL contains data in path, try to parse it
            let urlString = url.absoluteString
            appState.currentVehicle = VehicleQRParser.parse(urlString)
        }
    }
    
    private func createVehicleFromURLParameters(_ dict: [String: Any]) -> Vehicle? {
        guard let make = dict["make"] as? String,
              let model = dict["model"] as? String,
              let yearString = dict["year"] as? String,
              let year = Int(yearString) else {
            return nil
        }
        
        return Vehicle(
            id: dict["id"] as? String ?? UUID().uuidString,
            make: make,
            model: model,
            year: year,
            vin: dict["vin"] as? String,
            licensePlate: dict["license_plate"] as? String ?? dict["licensePlate"] as? String,
            color: dict["color"] as? String,
            mileage: dict["mileage"] as? Int ?? (dict["mileage"] as? String).flatMap(Int.init),
            engine: dict["engine"] as? String,
            transmission: dict["transmission"] as? String,
            fuelType: dict["fuel_type"] as? String ?? dict["fuelType"] as? String,
            price: dict["price"] as? Double ?? (dict["price"] as? String).flatMap(Double.init),
            description: dict["description"] as? String
        )
    }
}
