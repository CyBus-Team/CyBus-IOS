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
        var success: Bool = false
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case initFeature
        case initResponse(Bool)
        case onRateChanged(Int)
        case onSubmit
        case onDismiss
        case pushReview(email: String, rating: Int, message: String)
        case pushReviewResponse(Bool)
        case pushReviewError(String)
        
    }
    
    @Injected(\.rateUsUseCases) var rateUsUseCases: RateUsUseCasesProtocol
    
    var body: some ReducerOf<Self> {
        
        Reduce {
            state,
            action in
            switch action {
            case .binding(_):
                return .none
            case .initFeature:
                let needtoShow = rateUsUseCases.needToShow()
                return .send(.initResponse(needtoShow))
            case .initResponse(_):
                return .none
            case .onSubmit:
                if state.rate <= 3 {} else {}
                return .none
            case .onDismiss:
                return .none
            case .onRateChanged(let value):
                state.rate = value
                return .none
            case let .pushReview(email, rating, message):
                return .run { @MainActor send in
                    do {
                        let result = try await rateUsUseCases.pushReview(
                            for: email,
                            rating: rating,
                            message: message
                        )
                        send(.pushReviewResponse(result))
                    } catch {
                        send(
                            .pushReviewError(
                                "Error: \(error.localizedDescription)"
                            ))
                    }
                }
            case let .pushReviewError(error):
                // TODO: UI errors
                print("Error: \(error)")
                return .none
                
            case let .pushReviewResponse(result):
                state.success = result
                return .none
            }
        }
    }
    
}
