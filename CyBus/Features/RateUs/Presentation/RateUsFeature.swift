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
 
    @ObservableState
    struct State: Equatable {
        
        // State vars
        var needtoShown: Bool = false
        var text: String = ""
        var rate: Int = 4
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case initAppState
        case onSubmit
        case onDismiss
    }
    
    var body: some ReducerOf<Self> {
        
        @Injected(\.rateUsUseCases) var rateUsUseCases: RateUsUseCasesProtocol
      
        Reduce { state, action in
            switch action {
            case .binding(_):
                return .none
            case .initAppState:
                state.needtoShown =  rateUsUseCases.needToShow()
                return .none
            case .onSubmit:
                if state.rate < 3 {
                }
                else {
                }

                return .none
            case .onDismiss:
                return .none
            }
        }
    }
    
}
