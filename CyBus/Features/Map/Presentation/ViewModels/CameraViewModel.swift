//
//  CameraViewModel.swift
//  CyBus
//
//  Created by Vadim Popov on 04/10/2024.
//

import Foundation
import MapboxMaps

@MainActor
class CameraViewModel: ObservableObject {
    @Published var viewport: Viewport = .styleDefault
    
    private var zoom: Double = 14
    public let maxZoom: Double = 17
    public let minZoom: Double = 12
    
    private let locationViewModel: LocationViewModel
    
    init() {
        let locationUseCases = LocationUseCases()
        self.locationViewModel = LocationViewModel(locatonUseCases: locationUseCases)
        viewport = .camera(center: locationViewModel.location, zoom: zoom)
    }
    
    public func increaseZoom() {
        if (zoom < maxZoom) {
            zoom += 1
            viewport = .camera(zoom: zoom)
        }
    }
    
    public func decreaseZoom() {
        if (zoom > minZoom) {
            zoom -= 1
            viewport = .camera(zoom: zoom)
        }
    }
    
    public func goToCurrentLocation()  {
        viewport = .camera(center: locationViewModel.location, zoom: zoom)
    }
}
