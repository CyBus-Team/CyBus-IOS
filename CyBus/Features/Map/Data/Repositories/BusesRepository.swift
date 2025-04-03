//
//  BusesRepository.swift
//  CyBus
//
//  Created by Vadim Popov on 22/08/2024.
//

import Foundation

class BusesRepository: BusesRepositoryProtocol {
    
    private let urlSession: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    func fetchBuses() async throws -> BusesDTO {
        return BusesDTO(
            busCount: 10,
            buses: ["10": BusDTO(
                label: "String", latitude: 10, longitude: 10, bearing: 10, startTime: "", speedKmPerHour: 10, tripID: "", routeID: "", routeShortName: "", routeLongName: "", receivedFromBusAt: ""
            )]
        )
    }
    
}
