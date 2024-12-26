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
        
        var hasSelection: Bool { selectedBusGroupState != nil }
        var selectedBusGroupState: SelectedBusGroupState?
        
        var routes = RoutesFeature.State()
        
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
        
        case select(BusGroupEntity)
        case clearSelection
        case selectResponse
        
        case routes(RoutesFeature.Action)
    }
    
    @Dependency(\.busesUseCases) var busesUseCases
    
    var body: some ReducerOf<Self> {
        Scope(state: \.routes, action: \.routes) {
            RoutesFeature()
        }
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
                        let groupedBuses = try await busesUseCases.group(buses: buses, by: 100)
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
                
            case let .select(busGroup):
                if let selectedBusGroupState = state.selectedBusGroupState {
                    if selectedBusGroupState.group == busGroup {
                        let currentIndex = selectedBusGroupState.index
                        let newIndex = currentIndex + 1 >= busGroup.buses.count ? 0 : currentIndex + 1
                        state.selectedBusGroupState = SelectedBusGroupState(
                            group: busGroup,
                            index: newIndex,
                            bus: busGroup.buses[newIndex]
                        )
                    } else {
                        state.selectedBusGroupState = .defaultValue(group: busGroup)
                    }
                } else {
                    state.selectedBusGroupState = .defaultValue(group: busGroup)
                }
                return .send(.selectResponse)
            case .clearSelection:
                state.selectedBusGroupState = nil
                return .send(.selectResponse)
            case .selectResponse:
                if let selectedGroup = state.selectedBusGroupState {
                    let routeId = selectedGroup.bus.routeID
                    return .send(.routes(.select(id: routeId)))
                } else {
                    return .send(.routes(.clearSelection))
                }
            case .routes(_):
                return .none
            }
        }
    }
}
