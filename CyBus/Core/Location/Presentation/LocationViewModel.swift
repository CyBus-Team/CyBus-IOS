//
//  LocationViewModel.swift
//  CyBus
//
//  Created by Vadim Popov on 04/10/2024.
//

import CoreLocation

@MainActor
class LocationViewModel: ObservableObject {
    
    @Published public var location: CLLocationCoordinate2D
    
    private var locationUseCases: LocationUseCasesProtocol
    
    // Limassol
    private let initialLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 34.707130, longitude: 33.022617)
    
    init(locatonUseCases: LocationUseCasesProtocol, location: CLLocationCoordinate2D) {
        self.location = location
        self.locationUseCases = LocationUseCases()
    }
    
    init(locatonUseCases: LocationUseCasesProtocol) {
        self.location = initialLocation
        self.locationUseCases = LocationUseCases()
    }
    
    //TODO(vadim): Refactor to Reducer feature
    //    public func requestLocation() {
    //        do {
    //            try locationUseCases.requestLocation()
    //        } catch {
    //            print(error)
    //        }
    //    }
    
    public func listenChanges() {
        Task {
            do {
                try await locationUseCases.listenChanges { [weak self] newLocation in
                    self?.location = newLocation
                }
            } catch {
                // TODO: UI errors
                print("Failed to fetch location \(error)")
            }
        }
    }
}
