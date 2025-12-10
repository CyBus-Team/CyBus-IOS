//
//  AppState.swift
//  TestDrive
//
//  Created by Vadim Popov on 10/12/2025.
//

import SwiftUI
import Combine

@MainActor
class AppState: ObservableObject {
    @Published var currentVehicle: Vehicle?
    
    // Mock method to simulate URL parsing for testing
    func mockVehicleFromURL() {
        // Simulate URL: https://cybus.app/vehicle?make=Tesla&model=Model 3&year=2023&vin=5YJ3E1EA1KF123456&license_plate=ABC-1234&color=Pearl White&mileage=15000&engine=Electric&transmission=Single Speed&fuel_type=Electric&price=45000&description=Excellent condition, one owner, fully loaded with autopilot.
        let mockURL = URL(string: "https://cybus.app/vehicle?make=Tesla&model=Model%203&year=2023&vin=5YJ3E1EA1KF123456&license_plate=ABC-1234&color=Pearl%20White&mileage=15000&engine=Electric&transmission=Single%20Speed&fuel_type=Electric&price=45000&description=Excellent%20condition,%20one%20owner,%20fully%20loaded%20with%20autopilot.")!
        
        let vehicleData: [String: Any] = [
            "id": "test-1",
            "make": "Tesla",
            "model": "Model 3",
            "year": "2023",
            "vin": "5YJ3E1EA1KF123456",
            "license_plate": "ABC-1234",
            "color": "Pearl White",
            "mileage": "15000",
            "engine": "Electric",
            "transmission": "Single Speed",
            "fuel_type": "Electric",
            "price": "45000",
            "description": "Excellent condition, one owner, fully loaded with autopilot."
        ]
        
        currentVehicle = createVehicleFromDictionary(vehicleData)
    }
    
    private func createVehicleFromDictionary(_ dict: [String: Any]) -> Vehicle? {
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

