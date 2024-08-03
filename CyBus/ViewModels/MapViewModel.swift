//
//  MapViewModel.swift
//  CyBus
//
//  Created by Vadim Popov on 07/07/2024.
//

import Foundation
import Combine

class MapViewModel: ObservableObject {
    @Published var buses: [Bus] = []
    @Published var route: [BusRoute] = []
    
    private var timer: Timer?
    private var selectedBus: Bus?
    
    init() {
        startTimer()
    }
    
    deinit {
        stopTimer()
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { [weak self] _ in
            self?.loadBuses()
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func getRoute(for bus: Bus) {
        route = BusRouteRepository.shared.getRoute(for: bus.route.lineID) ?? []
        if let bus = buses.first(where: {$0 == bus}) {
            buses.removeAll()
            buses.append(bus)
            selectedBus = bus
        }
    }
    
    func clearRoute() {
        selectedBus = nil
        route.removeAll()
        loadBuses()
    }
    
    func loadBuses() {
        TransitAPIClient.shared.fetchBuses { [weak self] result in
            switch result {
            case .success(let buses):
                DispatchQueue.main.async {
                    if self?.selectedBus == nil {
                        self?.buses = buses
                    } else {
                        self?.buses = buses.filter { $0 == self?.selectedBus }
                    }
                    
                }
            case .failure(let error):
                // TODO: Display/Handle/Record the error
                print(error)
            }
        }
    }
}
