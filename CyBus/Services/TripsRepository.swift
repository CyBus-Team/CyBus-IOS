//
//  TripRepository.swift
//  CyBus
//
//  Created by Vadим Popov on 03/08/2024.
//

import Foundation

class TripsRepository {
    static let shared = TripsRepository()
    
    private var trips: [Trip]?
    
    private let filename = "trips"
    
    private init() {}
    
    func loadTrips() -> [Trip]? {
        if let trips = self.trips {
            return trips
        }
        
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
            // TODO: Errors localization - (issue)[https://github.com/PopovVA/CyBus/issues/4]
            print("File not found: \(filename).json")
            return nil
        }

        do {
            let data = try Data(contentsOf: url)
            let trips = try JSONDecoder().decode([Trip].self, from: data)
            self.trips = trips
            return trips
        } catch {
            // TODO: Errors localization - (issue)[https://github.com/PopovVA/CyBus/issues/4]
            print("Error loading or decoding file: \(error)")
            return nil
        }
    }
    
    func getTrips() -> [Trip]? {
        guard let trips = loadTrips() else {
            return nil
        }
        return trips
    }
    
    func getTrips(for routeId: String) -> [Trip]? {
        guard let trips = loadTrips() else {
            return nil
        }
        return trips.filter { $0.route_id == routeId }
    }
}
