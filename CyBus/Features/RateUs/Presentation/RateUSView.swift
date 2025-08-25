//
//  RootView.swift
//  CyBus
//
//  Created by Artem on 25. 8. 2025..
//

import SwiftUI
import ComposableArchitecture

struct RateUSView: View {
    
    let store: StoreOf<RateUsFeatures> = Store(initialState: RateUsFeatures.State()) {
        RateUsFeatures()
    }

    var body: some View {
        NavigationStack {
            switch store.page {
            case .home: HomeView()
            case .rateUs: RateUSView()
            }
        }
        
    }
}
