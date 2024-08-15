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
    @Published var route: BusRoute?
    
    private var timer: Timer?
    private var selectedBus: Bus?
    private var trips: [Trip] = []
    private var stopTimes: [StopTime] = []
    private var stops: [Stop] = []
    
    init() {
        startTimer()
        trips = TripsRepository.shared.getTrips() ?? []
        stopTimes = StopTimesRepository.shared.getStopTimes() ?? []
        stops = StopsRepository.shared.getStops() ?? []
    }
    
    deinit {
        stopTimer()
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.loadBuses()
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func getShapes(for bus: Bus) {
        if let bus = buses.first(where: {$0 == bus}) {
            let shapes = ShapesRepository.shared.getRoute(for: bus.route.id) ?? []
            let trip = TripsRepository.shared.getTrip(for: bus.route.id)
            let stopTimes = StopTimesRepository.shared.getStopTimes(by: trip?.trip_id ?? "") ?? []
            let stopIds = stopTimes.map{$0.stopId}
            let stops = StopsRepository.shared.getStops(by: stopIds) ?? []
            buses.removeAll()
            buses.append(bus)
            route = BusRoute(stops: stops, shapes: shapes)
            selectedBus = bus
        }
    }
    
    func clearRoute() {
        selectedBus = nil
        route = nil
        buses.removeAll()
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
                // TODO: Errors localization - (issue)[https://github.com/PopovVA/CyBus/issues/4]
                print(error)
            }
        }
    }
}
