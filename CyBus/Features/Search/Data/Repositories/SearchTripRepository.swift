//
//  SearchTripRepository.swift
//  CyBus
//
//  Created by Vadim Popov on 18/01/2025.
//

import Foundation

class SearchTripRepository: SearchTripRepositoryProtocol {
    private let bundle: Bundle
    
    init(bundle: Bundle = .main) {
        self.bundle = bundle
    }
    
}
