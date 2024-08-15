//
//  BusRouteRepository.swift
//  CyBus
//
//  Created by Vadim Popov on 03/08/2024.
//

import Foundation

class ShapesRepository {
    static let shared = ShapesRepository()
    
    private var shapes: [Shape]?
    
    private let filename = "shapes"
    
    private init() {}
    
    func loadShapes() -> [Shape]? {
        if let shapes = self.shapes {
            return shapes
        }
        
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
            print("File not found: \(filename).json")
            return nil
        }

        do {
            let data = try Data(contentsOf: url)
            let shapes = try JSONDecoder().decode([Shape].self, from: data)
            self.shapes = shapes
            return shapes
        } catch {
            print("Error loading or decoding file: \(error)")
            return nil
        }
    }
    
    func getRoute(for line: String) -> [Shape]? {
        guard let shapes = loadShapes() else {
            return nil
        }
        return shapes.filter { $0.id == line }
    }
}
