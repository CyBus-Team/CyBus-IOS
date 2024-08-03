//
//  BusRouteRepository.swift
//  CyBus
//
//  Created by Vadim Popov on 03/08/2024.
//

import Foundation

class BusRouteRepository {
    static let shared = BusRouteRepository()
    
    private var route: [BusRoute]?
    
    private let filename = "shapes"
    
    private init() {}
    
    func loadRoute() -> [BusRoute]? {
        if let route = self.route {
            return route
        }
        
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
            print("File not found: \(filename).json")
            return nil
        }

        do {
            let data = try Data(contentsOf: url)
            let route = try JSONDecoder().decode([BusRoute].self, from: data)
            self.route = route
            return route
        } catch {
            print("Error loading or decoding file: \(error)")
            return nil
        }
    }
    
    func getRoute(for line: String) -> [BusRoute]? {
        guard let route = loadRoute() else {
            return nil
        }
        return route.filter { $0.shape_id == line }
    }
}
