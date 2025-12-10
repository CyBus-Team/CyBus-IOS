//
//  Vehicle.swift
//  TestDrive
//
//  Created by Vadim Popov on 10/12/2025.
//

import Foundation

struct Vehicle: Codable, Identifiable {
    let id: String
    let make: String
    let model: String
    let year: Int
    let vin: String?
    let licensePlate: String?
    let color: String?
    let mileage: Int?
    let engine: String?
    let transmission: String?
    let fuelType: String?
    let price: Double?
    let description: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case make
        case model
        case year
        case vin
        case licensePlate = "license_plate"
        case color
        case mileage
        case engine
        case transmission
        case fuelType = "fuel_type"
        case price
        case description
    }
}

// Парсер для QR-кода
struct VehicleQRParser {
    static func parse(_ qrCode: String) -> Vehicle? {
        // Пытаемся распарсить как JSON
        guard let data = qrCode.data(using: .utf8) else { return nil }
        
        do {
            let vehicle = try JSONDecoder().decode(Vehicle.self, from: data)
            return vehicle
        } catch {
            // Если не JSON, пытаемся распарсить как URL с параметрами
            if let url = URL(string: qrCode),
               let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
               let queryItems = components.queryItems {
                
                var vehicleData: [String: Any] = [:]
                for item in queryItems {
                    vehicleData[item.name] = item.value
                }
                
                // Создаем Vehicle из параметров URL
                return createVehicleFromDictionary(vehicleData)
            }
            
            // Если это просто строка с данными, пытаемся распарсить как простой формат
            return parseSimpleFormat(qrCode)
        }
    }
    
    private static func createVehicleFromDictionary(_ dict: [String: Any]) -> Vehicle? {
        guard let id = dict["id"] as? String ?? UUID().uuidString as String?,
              let make = dict["make"] as? String,
              let model = dict["model"] as? String,
              let year = dict["year"] as? Int ?? Int(dict["year"] as? String ?? "") else {
            return nil
        }
        
        return Vehicle(
            id: id,
            make: make,
            model: model,
            year: year,
            vin: dict["vin"] as? String,
            licensePlate: dict["license_plate"] as? String ?? dict["licensePlate"] as? String,
            color: dict["color"] as? String,
            mileage: dict["mileage"] as? Int ?? Int(dict["mileage"] as? String ?? ""),
            engine: dict["engine"] as? String,
            transmission: dict["transmission"] as? String,
            fuelType: dict["fuel_type"] as? String ?? dict["fuelType"] as? String,
            price: dict["price"] as? Double ?? Double(dict["price"] as? String ?? ""),
            description: dict["description"] as? String
        )
    }
    
    private static func parseSimpleFormat(_ qrCode: String) -> Vehicle? {
        // Простой формат: make|model|year|vin|licensePlate
        let components = qrCode.components(separatedBy: "|")
        guard components.count >= 3,
              let year = Int(components[2]) else {
            return nil
        }
        
        return Vehicle(
            id: UUID().uuidString,
            make: components[0],
            model: components[1],
            year: year,
            vin: components.count > 3 ? components[3] : nil,
            licensePlate: components.count > 4 ? components[4] : nil,
            color: nil,
            mileage: nil,
            engine: nil,
            transmission: nil,
            fuelType: nil,
            price: nil,
            description: nil
        )
    }
}

