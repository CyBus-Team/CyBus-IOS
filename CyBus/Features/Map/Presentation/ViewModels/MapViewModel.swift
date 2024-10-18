//
//  MapViewModel.swift
//  CyBus
//
//  Created by Vadim Popov on 07/07/2024.
//

import Foundation
import Combine
import MapboxMaps

class MapViewModel: ObservableObject {
    @Published var buses: [BusEntity] = []
    @Published var selection: (bus: BusEntity, route: BusRouteEntity)?

    private let busesUsecases: BusesUseCasesProtocol
    private let routesUseCases: RoutesUseCasesProtocol
    private let mapUseCases: MapUseCasesProtocol
    
    private var timer: Timer?
    private let bundle = Bundle.main
    
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
            // TODO: UI errors
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
            // TODO: UI errors
            print("Failed to fetch busses \(error)")
        }
    }
    
    func onMapLoaded() {
        Task {
            do {
                try busesUsecases.fetchServiceUrl()
                try await routesUseCases.fetchRoutes()
            } catch {
                // TODO: UI errors
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
    
    public var hasSelection: Bool {
        get { selection != nil }
    }
}
