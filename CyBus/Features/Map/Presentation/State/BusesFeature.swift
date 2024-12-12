//
//  BusesFeature.swift
//  CyBus
//
//  Created by Vadim Popov on 23/11/2024.
//

import ComposableArchitecture

@Reducer
struct BusesFeature {
    
    static let tick = 5
    
    @ObservableState
    struct State: Equatable {
        var isInitialized: Bool = false
        var isFetching: Bool = false
        var groupedBuses: [BusGroupEntity] = []
        var hasSelectedBus: Bool = false
        var selectedBus : BusEntity? {
            didSet {
                hasSelectedBus = true
            }
        }
    }
    
    enum Action {
        case setUp
        case setUpResponse(Bool, error: String?)
        
        case startFetchingLoop
        case stopFetchingLoop
        case tick
        
        case fetchBuses
        case fetchBusesResponse([BusGroupEntity])
        case fetchBusesError(String)
        
        case selectBus(BusEntity)
        case clearSelection
    }
    
    @Dependency(\.busesUseCases) var busesUseCases
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .setUpResponse(isInited, error):
                state.isInitialized = isInited
                if !isInited {
                    // TODO: UI errors
                    print(error ?? "Initialization failed")
                    return .none
                }
                return .send(.startFetchingLoop)
                
            case .setUp:
                return .run { send in
                    do {
                        try await busesUseCases.fetchServiceUrl()
                        return await send(.setUpResponse(true, error: nil))
                    } catch {
                        return await send(.setUpResponse(false, error: error.localizedDescription))
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
                        let groupedBuses = try await busesUseCases.group(buses: buses, by: 300)
                        send(.fetchBusesResponse(groupedBuses))
                    } catch {
                        send(.fetchBusesError("Error: \(error.localizedDescription)"))
                    }
                }
                
            case let .fetchBusesError(error):
                // TODO: UI errors
                print("Error: \(error)")
                return .none
                
            case let .fetchBusesResponse(groupedBuses):
                state.groupedBuses = groupedBuses
                return .none
                
            case let .selectBus(bus):
                state.selectedBus = bus
                return .none
                
            case .clearSelection:
                state.hasSelectedBus.toggle()
                return .none
                
            }
        }
    }
}
