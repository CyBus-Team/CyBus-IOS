import ComposableArchitecture

enum OnboardingPage {
    case welcome
    case geolocation
    case login
}

@Reducer
struct OnboardingFeatures {
    
    static let onboardingKey = "hasLaunchedBefore"
    
    @ObservableState
    struct State: Equatable {
        var page: OnboardingPage = .welcome
        var welcome = OnboardingWelcomeFeature.State()
        var geolocation = OnboardingRequestGeolocationFeature.State()
    }
    
    enum Action {
        //Welcome
        case welcome(OnboardingWelcomeFeature.Action)
        
        //Location
        case geolocation(OnboardingRequestGeolocationFeature.Action)
        
        //Sign in
        case notNowSignInTapped
        case signInTapped
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.welcome, action: \.welcome) {
            OnboardingWelcomeFeature()
        }
        Scope(state: \.geolocation, action: \.geolocation) {
            OnboardingRequestGeolocationFeature()
        }
        Reduce { state, action in
            switch action {
                
                // Welcome
            case .welcome(.getStartTapped):
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
