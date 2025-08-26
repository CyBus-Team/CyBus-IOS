//
//  GoogleAdsUseCases.swift
//  CyBus
//
//  Created by Vadim Popov on 25/08/2025.
//

import GoogleMobileAds
import FactoryKit

class GoogleAdsUseCases : NSObject, AdvertisingUseCasesProtocol, FullScreenContentDelegate {
    
    private var interstitialAd: InterstitialAd?
    
    private var appConfiguration: AppConfiguration
    
    init(appConfiguration: AppConfiguration = Container.shared.appConfiguration()) {
        self.appConfiguration = appConfiguration
    }
    
    func initSDK() async throws {
        await MobileAds.shared.start()
    }
    
    func load() async throws {
        interstitialAd = try await InterstitialAd.load(
            with: appConfiguration.interstitialAdUnitID,
            request: Request()
        )
        interstitialAd?.fullScreenContentDelegate = self
    }
    
    func show() async throws {
        guard let interstitialAd = interstitialAd else {
          return print("Ad wasn't ready.")
        }

        await interstitialAd.present(from: nil)
    }
    
}
