//
//  RootStoreTests.swift
//  CyBus
//
//  Created by Vadim Popov on 19/10/2024.
//

//import ComposableArchitecture
//import Foundation
import Testing
import ComposableArchitecture

@testable import CyBus

@MainActor
struct RootFeatureTests {
    
  @Test
  func basics() async {
      
      let store = TestStore(initialState: RootFeature.State()) {
          RootFeature()
      }
      
      await store.send(.initApp) {
//          $0.page = .onboarding
          $0.page = .home
      }
  }
}
