//
//  BusStopTimesRepository.swift
//  CyBus
//
//  Created by Vadim Popov on 03/08/2024.
//

import Foundation

class BusStopTimesRepository {
    static let shared = BusStopTimesRepository()
    
    private var stopTimes: [BusStopTime]?
    
    private let filename = "stop_times"
    
    private init() {}
    
    func loadStopTimes() -> [BusStopTime]? {
        if let stopTimes = self.stopTimes {
            return stopTimes
        }
        
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
            print("File not found: \(filename).json")
            return nil
        }

        do {
            let data = try Data(contentsOf: url)
            let stopTimes = try JSONDecoder().decode([BusStopTime].self, from: data)
            self.stopTimes = stopTimes
            return stopTimes
        } catch {
            print("Error loading or decoding file: \(error)")
            return nil
        }
    }
    
    func getStopTimes() -> [BusStopTime]? {
        guard let stopTimes = loadStopTimes() else {
            return nil
        }
        return stopTimes
    }
}

