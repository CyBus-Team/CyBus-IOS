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
        var text: String = ""
        var rate: Int = 4
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case initFeature
        case initResponse(Bool)
        case onSubmit
        case onDismiss
    }
    
    @Injected(\.rateUsUseCases) var rateUsUseCases: RateUsUseCasesProtocol
    
    var body: some ReducerOf<Self> {
      
        Reduce { state, action in
            switch action {
            case .binding(_):
                return .none
            case .initFeature:
                let needtoShow = rateUsUseCases.needToShow()
                return .send(.initResponse(needtoShow))
            case .initResponse(_):
                return .none
            case .onSubmit:
                if state.rate < 3 {} else {}
                return .none
            case .onDismiss:
                return .none
            }
        }
    }
    
}
