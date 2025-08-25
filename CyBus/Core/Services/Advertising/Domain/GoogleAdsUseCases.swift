//
//  GoogleAdsUseCases.swift
//  CyBus
//
//  Created by Vadim Popov on 25/08/2025.
//

import GoogleMobileAds

class GoogleAdsUseCases : AdvertisingUseCasesProtocol {
    
    private var interstitialAd: InterstitialAd?
    
    func initSDK() async throws {
        await MobileAds.shared.start()
    }
    
    func loadAd() async throws {
        
    }
    
    func showAd() async throws {
        
    }
    
    
}
