//
//  AdvertisingFeature.swift
//  CyBus
//
//  Created by Vadim Popov on 25/08/2025.
//

import CoreLocation
import ComposableArchitecture
import FactoryKit
import AppTrackingTransparency
import UserMessagingPlatform

@Reducer
struct AdvertisingFeature {
    
    enum InitializationStatus {
        case notInitialized
        case failedToInitialize
        case initialized
    }
    
    @ObservableState
    struct State : Equatable {
        var initializationStatus: InitializationStatus = .notInitialized
        var attStatus: ATTrackingManager.AuthorizationStatus?
        var umpStatus: ConsentStatus?
        var adIsReady: Bool = false
    }
    
    enum Action {
        // Method to request User Messaging Platform (UMP) consent from the user.
        case requestUMP

        // Method to handle the UMP consent status returned from the system request.
        case responseUMP(ConsentStatus)

        // Method to request App Tracking Transparency (ATT) authorization from the user.
        case requestATT

        // Method to handle the ATT authorization status returned from the system request.
        case responseATT(ATTrackingManager.AuthorizationStatus)

        // Method to initialize the Mobile Ads SDK. The SDK should only be initialized once.
        case initSDK

        // Method to handle the response after attempting to initialize the Mobile Ads SDK.
        case initializationResponse(InitializationStatus)

        // Method to load an advertisement.
        case loadAd

        // Method to handle the response after attempting to load an advertisement.
        case loadAdResponse(Bool)

        // Method to show an advertisement to the user.
        case showAd

        // Method to handle the response after showing an advertisement.
        case showAdResponse
    }
    
    @Injected(\.advertisingUseCases) var advertisingUseCases: AdvertisingUseCasesProtocol
    @Injected(\.attUseCases) var attUseCases: any ConsentsUseCasesProtocol
    @Injected(\.umpUseCases) var umpUseCases: any ConsentsUseCasesProtocol
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
            // Method to initialize the Mobile Ads SDK.
            case .initSDK:
                guard ConsentInformation.shared.canRequestAds else {
                    return .none
                }
                return .run { @MainActor send in
                    do {
                        try await advertisingUseCases.initSDK()
                        send(.initializationResponse(.initialized))
                        send(.loadAd)
                    } catch {
                        send(.initializationResponse(.failedToInitialize))
                    }
                }
                return .none
                
            // Method to handle the response after attempting to initialize the Mobile Ads SDK.
            case let .initializationResponse(status):
                state.initializationStatus = status
                return .none
                
            // Method to request App Tracking Transparency (ATT) authorization.
            case .requestATT:
                return .run { @MainActor send in
                    let status = try await attUseCases.requestConsent()
                    send(.responseATT(status as! ATTrackingManager.AuthorizationStatus))
                }
                return .none
                
            // Method to handle the ATT authorization response and update the state.
            case let .responseATT(status):
                state.attStatus = status
                return .none
                
            // Method to request User Messaging Platform (UMP) consent.
            case .requestUMP:
                return .run { @MainActor send in
                    // status: .authorized / .denied / .restricted / .notDetermined
                    let status = try await umpUseCases.requestConsent()
                    send(.responseUMP(status as! ConsentStatus))
                }
                return .none
                
            // Method to handle the UMP consent response and update the state.
            case let .responseUMP(formStatus):
                state.umpStatus = formStatus
                return .none
                
            // Method to load an advertisement.
            case .loadAd:
                guard state.initializationStatus == .initialized else { return .none }
                return .run { @MainActor send in
                    do {
                        try await advertisingUseCases.load()
                        send(.loadAdResponse(true))
                    } catch {
                        send(.loadAdResponse(false))
                    }
                }
                
            // Method to handle the advertisement load result and update readiness.
            case let .loadAdResponse(isReady):
                state.adIsReady = isReady
                return .none
                
            // Method to show an advertisement; triggers reload after showing.
            case .showAd:
                guard state.initializationStatus == .initialized else { return .none }
                guard state.adIsReady else { return .none }
                return .run { @MainActor send in
                    do {
                        try await advertisingUseCases.show()
                        send(.loadAd)
                    } catch {
                        send(.loadAd)
                    }
                }
            // Method to handle the post-show state and trigger a reload.
            case .showAdResponse:
                state.adIsReady = false
                return .run { @MainActor send in
                    send(.loadAd)
                }
            }
        }
    }
}
