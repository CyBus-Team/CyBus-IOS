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
    private var lineId: String?
    
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
    
    func getRoute(for line: String) {
        route = BusRouteRepository.shared.getRoute(for: line) ?? []
        if let bus = buses.first(where: {$0.route.lineID == line}) {
            buses.removeAll()
            buses.append(bus)
            lineId = line
        }
    }
    
    func clearRoute() {
        lineId = nil
        route.removeAll()
        loadBuses()
    }
    
    func loadBuses() {
        TransitAPIClient.shared.fetchBuses { [weak self] result in
            switch result {
            case .success(let buses):
                DispatchQueue.main.async {
                    if self?.lineId == nil {
                        self?.buses = buses
                    } else {
                        self?.buses = buses.filter{$0.route.lineID == self?.lineId}
                    }
                    
                }
            case .failure(let error):
                // TODO: Display/Handle/Record the error
                print(error)
            }
        }
    }
}
