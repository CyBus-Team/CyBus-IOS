//
//  BusStopsRepository.swift
//  CyBus
//
//  Created by Vadim Popov on 03/08/2024.
//

import Foundation

class BusStopsRepository {
    static let shared = BusStopsRepository()
    
    private var stops: [BusStop]?
    
    private let filename = "stops"
    
    private init() {}
    
    func loadStops() -> [BusStop]? {
        if let stops = self.stops {
            return stops
        }
        
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
            // TODO: Errors localization - (issue)[https://github.com/PopovVA/CyBus/issues/4]
            print("File not found: \(filename).json")
            return nil
        }

        do {
            let data = try Data(contentsOf: url)
            let stops = try JSONDecoder().decode([BusStop].self, from: data)
            self.stops = stops
            return stops
        } catch {
            // TODO: Errors localization - (issue)[https://github.com/PopovVA/CyBus/issues/4]
            print("Error loading or decoding file: \(error)")
            return nil
        }
    }
    
    func getStops() -> [BusStop]? {
        guard let stops = loadStops() else {
            return nil
        }
        return stops
    }
}
