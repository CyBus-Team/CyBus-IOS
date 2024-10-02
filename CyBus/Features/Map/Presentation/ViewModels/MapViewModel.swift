//
//  MapViewModel.swift
//  CyBus
//
//  Created by Vadim Popov on 07/07/2024.
//

import Foundation
import Combine
@_spi(Experimental) import MapboxMaps

class MapViewModel: ObservableObject {
    @Published var buses: [BusEntity] = []
    @Published var selection: (bus: BusEntity, route: BusRouteEntity)?
    @Published var viewport: Viewport = .styleDefault
    
    private let busesUsecases: BusesUseCasesProtocol
    private let routesUseCases: RoutesUseCasesProtocol
    private let mapUseCases: MapUseCasesProtocol
    
    private var timer: Timer?
    private let bundle = Bundle.main
    private let center = CLLocationCoordinate2D(latitude: 34.707130, longitude: 33.022617)
    private var zoom: Double = 14
    public let maxZoom: Double = 17
    public let minZoom: Double = 12
    
    init() {
        do {
            let routesRepository = RoutesRepository(bundle: bundle)
            routesUseCases = RoutesUseCases(repository: routesRepository)
            busesUsecases = BusesUseCases(
                repository: BusesRepository(urlSession: URLSession.shared,bundle: bundle),
                routesUseCases: routesUseCases
            )
            mapUseCases = MapUseCases(bundle: bundle)
            try mapUseCases.setup()
            self.startTimer()
        } catch {
            print("Failed to init map \(error)")
        }
    }
    
    // Fetch data
    
    deinit {
        stopTimer()
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            Task { [weak self] in
                try await self?.fetchBuses()
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    @MainActor
    private func fetchBuses() async throws {
        do {
            let buses = try await busesUsecases.fetchBuses()
            if let selectedBus = selection {
                self.buses = buses.filter { $0 == selectedBus.bus }
            } else {
                self.buses = buses
            }
        } catch {
            print("Failed to fetch busses \(error)")
        }
    }
    
    func onMapLoaded() {
        viewport = .camera(center: center, zoom: zoom)
        Task {
            do {
                try busesUsecases.fetchServiceUrl()
                try await routesUseCases.fetchRoutes()
            } catch {
                print("Failed to load Map \(error)")
            }
        }
    }
    
    // UI Methods
    
    func onSelectBus(bus: BusEntity) {
        let route = routesUseCases.getRoute(for: bus.routeID)
        selection = (bus, route)
    }
    
    func onClearSelection()  {
        selection = nil
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
    
    public func goToCurrentLocation() {
        // TODO: Get current location
        viewport = .camera(center: center, zoom: zoom, bearing: 0, pitch: 0)
    }
    
    public var hasSelection: Bool {
        get { selection != nil }
    }
}
