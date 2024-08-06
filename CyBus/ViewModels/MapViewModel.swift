//
//  MapViewModel.swift
//  CyBus
//
//  Created by Vadim Popov on 07/07/2024.
//

import Foundation
import Combine

class MapViewModel: ObservableObject {
    //Public state vars
    @Published var buses: [Bus] = []
    @Published var selectedBus: Bus? {
        didSet {
            if let bus = selectedBus {
                print("selectedBus \(bus)")
                let trip = trips.filter( {$0.route_id == bus.route.id } ).first
                print("trip \(trip)")
                let tripStopTimes = stopTimes.filter { $0.trip_id == trip?.trip_id }
                print("tripStopTimes \(tripStopTimes)")
                let tripStops = tripStopTimes.compactMap { stopTime in
                    stops.first { $0.stop_id == stopTime.stop_id }
                }
                print("tripStops \(tripStops)")
                let tripShapes = shapes.filter { $0.shape_id == trip?.shape_id }
                print("tripShapes \(tripShapes)")
                selectedRoute = RouteData(
                    tripId: trip!.trip_id,
                    stops: tripStops,
                    shapes: tripShapes
                )
                print("selectedRoute \(selectedRoute)")
            } else {
                selectedRoute = nil
            }
            
        }
    }
    @Published var selectedRoute: RouteData?
    
    private var timer: Timer?
    
    // Route data
    private var trips: [Trip] = []
    private var shapes: [BusShape] = []
    private var stopTimes: [BusStopTime] = []
    private var stops: [BusStop] = []
    
    init() {
        print("init init init")
        trips = TripsRepository.shared.getTrips() ?? []
        print("vad trips done \(trips.count)")
        shapes = BusShapesRepository.shared.getShapes() ?? []
        print("vad shapes done \(shapes.count)")
        stopTimes = BusStopTimesRepository.shared.getStopTimes() ?? []
        print("vad stopTimes done \(stopTimes.count)")
        stops = BusStopsRepository.shared.getStops() ?? []
        print("vad stops done \(stops.count)")
        startTimer()
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
    
    func getRoute(for bus: Bus) {
        if let bus = buses.first(where: {$0 == bus}) {
            selectedBus = bus
        }
    }
    
    func clearRoute() {
        selectedBus = nil
        buses.removeAll()
        loadBuses()
    }
    
    func loadBuses() {
        TransitAPIClient.shared.fetchBuses { [weak self] result in
            switch result {
            case .success(let buses):
                DispatchQueue.main.async {
                    self?.buses = buses
                }
            case .failure(let error):
                // TODO: Errors localization - (issue)[https://github.com/PopovVA/CyBus/issues/4]
                print(error)
            }
        }
    }
}
