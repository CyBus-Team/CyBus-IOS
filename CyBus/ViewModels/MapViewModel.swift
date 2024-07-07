//
//  MapViewModel.swift
//  CyBus
//
//  Created by Vadim Popov on 07/07/2024.
//

import Foundation
import Combine

class MapViewModel: ObservableObject {
    @Published var buses: [Bus] = []
    
    private var timer: Timer?
    
    init() {
        startTimer()
    }
    
    deinit {
        stopTimer()
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { [weak self] _ in
            self?.loadBuses()
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func loadBuses() {
        TransitAPIClient.shared.fetchBuses { [weak self] result in
            switch result {
            case .success(let buses):
                DispatchQueue.main.async {
                    self?.buses = buses
                }
            case .failure(let error):
                // TODO: Display/Handle/Record the error
                print(error)
            }
        }
    }
}
