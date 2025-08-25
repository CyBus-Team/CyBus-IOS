//
//  RateUsFeatures.swift
//  CyBus
//
//  Created by Artem on 28. 7. 2025..
//
import ComposableArchitecture

@Reducer
struct RateUsFeatures {
    
    static let rateUsKey = "isShown"
 
    @ObservableState
    struct State {
        
        // State vars
        var isShown: Bool = false
        var text: String = ""
        var rate: Int = 4
        
        // Futures
//        var page: .home;
        
    }
    
    enum Action {
        case initAppState
        case onSubmit
        case onDismiss
    }
    
    var body: some ReducerOf<Self> {
      
        Reduce { state, action in
            switch action {
               
            case .initAppState:
                
                
            case .onSubmit:
                if state.rate < 3 {  
                }
                else {
                }

                return .none
            case .onDismiss:
                state.isShown = true
                return .none
            }
        }
    }
    
}
