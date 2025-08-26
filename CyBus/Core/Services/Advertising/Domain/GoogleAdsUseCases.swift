//
//  GoogleAdsUseCases.swift
//  CyBus
//
//  Created by Vadim Popov on 25/08/2025.
//

import GoogleMobileAds

class GoogleAdsUseCases : NSObject, AdvertisingUseCasesProtocol, FullScreenContentDelegate {
    
    private var interstitialAd: InterstitialAd?
    
    func initSDK() async throws {
        await MobileAds.shared.start()
    }
    
    func load() async throws {
        guard let adUnitID = Bundle.main.object(forInfoDictionaryKey: "GADApplicationIdentifier") as? String else {
            print("Error: GADApplicationIdentifier key not found in Info.plist")
            return
        }
        
        interstitialAd = try await InterstitialAd.load(
            with: adUnitID,
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
