//
//  RateUsFeatures.swift
//  CyBus
//
//  Created by Artem on 28. 7. 2025..
//
import ComposableArchitecture
import FactoryKit

@Reducer
struct RateUsFeatures {
    
    static let rateUsKey = "isShown"
    
    enum Page {
        case home
        case rateUs
    }
 
    @ObservableState
    struct State {
        
        // State vars
        var isShown: Bool = false
        var text: String = ""
        var rate: Int = 4
        var page = Page.rateUs
    }
    
    enum Action {
        case initAppState
        case onSubmit
        case onDismiss
    }
    
    var body: some ReducerOf<Self> {
        
        @Injected(\.rateUsUseCases) var rateUsUseCases: RateUsUseCasesProtocol
      
        Reduce { state, action in
            switch action {
               
            case .initAppState:
                let isShownBefore = rateUsUseCases.isShownBefore()
                state.page = isShownBefore ? .rateUs : .home
                return .none
            case .onSubmit:
                if state.rate < 3 {  
                }
                else {
                }

                return .none
            case .onDismiss:
                state.isShown = true
                state.page = .home
                return .none
            }
        }
    }
    
}
