//
//  BusRouteRepository.swift
//  CyBus
//
//  Created by Vadim Popov on 03/08/2024.
//

import Foundation

class BusShapesRepository {
    static let shared = BusShapesRepository()
    
    private var shapes: [BusShape]?
    
    private let filename = "shapes"
    
    private init() {}
    
    func loadShapes() -> [BusShape]? {
        if let shapes = self.shapes {
            return shapes
        }
        
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
            // TODO: Errors localization - (issue)[https://github.com/PopovVA/CyBus/issues/4]
            print("File not found: \(filename).json")
            return nil
        }

        do {
            let data = try Data(contentsOf: url)
            let shapes = try JSONDecoder().decode([BusShape].self, from: data)
            self.shapes = shapes
            return shapes
        } catch {
            // TODO: Errors localization - (issue)[https://github.com/PopovVA/CyBus/issues/4]
            print("Error loading or decoding file: \(error)")
            return nil
        }
    }
    
    func getShapes() -> [BusShape]? {
        guard let shapes = loadShapes() else {
            return nil
        }
        return shapes
    }
}
