//
//  RateUsUseCases.swift
//  CyBus
//
//  Created by Artem on 5. 8. 2025..
//
import Foundation
import ComposableArchitecture
import FactoryKit

public class RateUsUseCases : RateUsUseCasesProtocol {
    @Injected(\.rateUsRepository) var repository: RateUsRepositoryProtocol
    
    func finished() {
        repository.finished()
    }
    
    func isShownBefore() -> Bool {
        !repository.isShownBefore()
    }

}
