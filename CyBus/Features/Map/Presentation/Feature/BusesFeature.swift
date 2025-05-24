//
//  BusesFeature.swift
//  CyBus
//
//  Created by Vadim Popov on 23/11/2024.
//

import ComposableArchitecture
import FactoryKit
import SwiftUI

typealias Distance = Double

@Reducer
struct BusesFeature {
    
    static let tick = 5
    
    @ObservableState
    struct State: Equatable {
        var distance: Distance = MapFeature.defaultCameraDistance
        var isFetching: Bool = false
        
        var buses: [BusEntity] = []
        var clusters: [BusClusterEntity] = []

        var selectedBus: BusEntity?
        var routes = RoutesFeature.State()
    }
    
    enum Action {
        
        case startFetchingLoop
        case stopFetchingLoop
        case tick
        
        case fetchBuses
        case fetchBusesResponse([BusEntity], [BusClusterEntity])
        case fetchBusesError(String)
        
        case select(BusEntity)
        case clearSelection
        case selectResponse
        
        case onDistanceChanged(Distance)
        
        case routes(RoutesFeature.Action)
    }
    
    @Injected(\.busesUseCases) var busesUseCases: BusesUseCasesProtocol
    
    var body: some ReducerOf<Self> {
        Scope(state: \.routes, action: \.routes) {
            RoutesFeature()
        }
        Reduce { state, action in
            switch action {
            case .startFetchingLoop:
                state.isFetching = true
                return .run { send in
                    while true {
                        try await Task.sleep(for: .seconds(BusesFeature.tick))
                        await send(.tick)
                    }
                }
                
            case .stopFetchingLoop:
                state.isFetching = false
                return .none
                
            case .tick:
                return state.isFetching ? .send(.fetchBuses) : .none
                
            case .fetchBuses:
                let distance = state.distance
                return .run { @MainActor send in
                    do {
                        let buses = try await busesUseCases.fetchBuses()
                        let clusters = busesUseCases.fetchClusters(from: buses, withDistance: distance);
                        send(.fetchBusesResponse(buses, clusters))
                    } catch {
                        send(.fetchBusesError("Error: \(error.localizedDescription)"))
                    }
                }
                
            case let .fetchBusesError(error):
                // TODO: UI errors
                print("Error: \(error)")
                return .none
                
            case let .fetchBusesResponse(buses, clusters):
                withAnimation(.easeInOut(duration: 1.0)) {
                    state.buses = buses
                    state.clusters = clusters
                }
                return .none
                
            case let .select(bus):
                state.selectedBus = bus
                return .send(.selectResponse)
            case .clearSelection:
                state.selectedBus = nil
                return .send(.selectResponse)
            case .selectResponse:
                if let routeId = state.selectedBus?.routeID {
                    return .send(.routes(.select(id: routeId)))
                } else {
                    return .send(.routes(.clearSelection))
                }
            case .routes(_):
                return .none
            case let .onDistanceChanged(distance):
                if (distance.rounded() != state.distance.rounded()) {
                    state.distance = distance
                }
                return .none
            }
        }
    }
}
