//
//  RateUsFeatures.swift
//  CyBus
//
//  Created by Artem on 28. 7. 2025..
//
import ComposableArchitecture
import FactoryKit

@Reducer
struct RateUsFeature {
    
    @ObservableState
    struct State: Equatable {
        var message: String = ""
        var rate: Int = 5
        var email: String = ""
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case onDismiss
        case initFeature
        case initResponse(Bool)
        case onRateChanged(Int)
        case submitReview
        case submitReviewResponse
        case submitReviewError(String)
    }
    
    @Injected(\.rateUsUseCases) var rateUsUseCases: RateUsUseCasesProtocol
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state,action in
            switch action {
            case .binding(_):
                return .none
            case .initFeature:
                let needtoShow = rateUsUseCases.needToShow()
                return .send(.initResponse(needtoShow))
            case .initResponse(_):
                return .none
            case .onDismiss:
                return .none
            case .onRateChanged(let rate):
                state.rate = rate
                return .none
            case .submitReview:
                let email = state.email
                let rate = state.rate
                let message = state.message
                return .run { @MainActor send in
                    do {
                        try await rateUsUseCases.submit(
                            email: email,
                            rating: rate,
                            message: message
                        )
                        send(.submitReviewResponse)
                    } catch {
                        send(.submitReviewError("Error: \(error.localizedDescription)"))
                    }
                }
            case let .submitReviewError(error):
                // TODO: UI errors
                print("Error: \(error)")
                return .none
                
            case .submitReviewResponse:
                return .none
            }
        }
    }
    
}
