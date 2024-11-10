//
//  HomeFeature.swift
//  CyBus
//
//  Created by Vadim Popov on 29/10/2024.
//

import ComposableArchitecture

@Reducer
struct HomeFeatures {
    
    @ObservableState
    struct State: Equatable {}
    
    enum Action {}
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            return .none
        }
    }
    
}
