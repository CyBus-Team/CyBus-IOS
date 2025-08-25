//
//  AdvertisingUseCasesProtocol.swift
//  CyBus
//
//  Created by Vadim Popov on 25/08/2025.
//

import ObjectiveC

protocol AdvertisingUseCasesProtocol {
    
    // Method to initialize the advertising SDK. Should be called once during app startup.
    func initSDK() async throws
    
    // Method to load an advertisement. Prepares the ad content to be shown later.
    func load() async throws
    
    // Method to display a loaded advertisement to the user.
    func show() async throws
}
