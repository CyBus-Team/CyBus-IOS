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
                .onAppear {
                    #if DEBUG
                    // Mock vehicle data for testing (comment out for production)
                    // Option 1: Use AppState method (simpler)
                    // appState.mockVehicleFromURL()
                    
                    // Option 2: Use TestDriveApp method (simulates full URL parsing)
                    // mockURLParsing()
                    #endif
                }
        }
    }
    
    @MainActor
    func handleIncomingURL(_ url: URL) {
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
    
    #if DEBUG
    // Mock method to simulate URL parsing for testing
    func mockURLParsing() {
        // Simulate opening a URL with vehicle data
        let mockURL = URL(string: "https://cybus.app/vehicle?make=Tesla&model=Model%203&year=2023&vin=5YJ3E1EA1KF123456&license_plate=ABC-1234&color=Pearl%20White&mileage=15000&engine=Electric&transmission=Single%20Speed&fuel_type=Electric&price=45000&description=Excellent%20condition,%20one%20owner,%20fully%20loaded%20with%20autopilot.")!
        handleIncomingURL(mockURL)
    }
    #endif
    
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
