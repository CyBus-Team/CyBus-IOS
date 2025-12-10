//
//  AppState.swift
//  TestDrive
//
//  Created by Vadim Popov on 10/12/2025.
//

import SwiftUI
import Combine

@MainActor
class AppState: ObservableObject {
    @Published var currentVehicle: Vehicle?
}

