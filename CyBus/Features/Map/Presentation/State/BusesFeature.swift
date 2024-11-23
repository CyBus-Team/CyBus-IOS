//
//  BusesFeature.swift
//  CyBus
//
//  Created by Vadim Popov on 23/11/2024.
//

import ComposableArchitecture
import MapboxMaps
import UIKit

@Reducer
struct BusesFeature {
    
    static let tick = 10
    
    @ObservableState
    struct State: Equatable {
        var isInitialized: Bool = false
        var isFetching: Bool = false
        var buses: [BusEntity] = []
        var hasSelectedBus: Bool = false {
            didSet {
                selectedBus = nil
                selectedRoute = nil
            }
        }
        var selectedBus : BusEntity?
        var selectedRoute: BusRouteEntity?
    }
    
    enum Action {
        case initialize
        case initializeResponse(Bool, error: String?)
        
        case startFetchingLoop
        case stopFetchingLoop
        case tick
        
        case fetchBuses
        case fetchBusesResponse([BusEntity])
        case fetchBusesError(String)
        
        case selectBus(BusEntity)
        case clearSelection
    }
    
    @Dependency(\.busesUseCases) var busesUseCases
    @Dependency(\.routesUseCases) var routesUseCases
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .initializeResponse(isInited, error):
                state.isInitialized = isInited
                if !isInited {
                    // TODO: UI errors
                    print(error ?? "Initialization failed")
                    return .none
                }
                return .send(.startFetchingLoop)
                
            case .initialize:
                return .run { send in
                    do {
                        try busesUseCases.fetchServiceUrl()
                        return await send(.initializeResponse(true, error: nil))
                    } catch {
                        return await send(.initializeResponse(false, error: error.localizedDescription))
                    }
                }
                
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
                return .run { @MainActor send in
                    do {
                        let buses = try await busesUseCases.fetchBuses()
                        send(.fetchBusesResponse(buses))
                    } catch {
                        send(.fetchBusesError("Error: \(error.localizedDescription)"))
                    }
                }
                
            case let .fetchBusesError(error):
                // TODO: UI errors
                print("Error: \(error)")
                return .none
                
            case let .fetchBusesResponse(buses):
                state.buses = buses
                return .none
                
            case let .selectBus(bus):
                state.selectedRoute = routesUseCases.getRoute(for: bus.routeID)
                state.selectedBus = bus
                return .none
                
            case .clearSelection:
                state.hasSelectedBus.toggle()
                return .none
                
            }
        }
    }
}
