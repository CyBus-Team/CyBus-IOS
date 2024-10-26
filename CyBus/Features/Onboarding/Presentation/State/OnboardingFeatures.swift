import ComposableArchitecture

enum OnboardingPage {
    case welcome
    case geolocation
    case login
}

@Reducer
struct OnboardingFeatures {
    
    static let onboardingKey = "skipOnboarding"
    
    @ObservableState
    struct State: Equatable {
        var page: OnboardingPage = .welcome
        var geolocation = RequestGeolocationFeature.State()
    }
    
    enum Action {
        //Welcome
        case getStartTapped
        
        //Location
        case geolocation(RequestGeolocationFeature.Action)
        
        //Sign in
        case notNowSignInTapped
        case signInTapped
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.geolocation, action: \.geolocation) {
            RequestGeolocationFeature()
        }
        Reduce { state, action in
            switch action {
                
                // Welcome
            case .getStartTapped:
                state.page = .geolocation
                return .none
                
                // Geolocation
            case .geolocation(.nextTapped), .geolocation(.notNowTapped):
                state.page = .login
                return .none
            case let .geolocation(.permissionResponse(allowed, _)):
                if allowed {
                    state.page = .login
                }
                return .none
            case .geolocation(_):
                return .none
                
                // Sign in
            case .notNowSignInTapped:
                return .none
            case .signInTapped:
                return .none
            }
        }
    }
}
