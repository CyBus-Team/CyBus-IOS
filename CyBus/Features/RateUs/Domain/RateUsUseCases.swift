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
    
    func needToShow() -> Bool {
        !repository.isShownBefore()
    }
    
    func pushReview(for email: String, rating: Int, message: String) async throws -> Bool {
        do {
            let pushResonse = try await repository.pushReview(for: email, rating: rating, message: message)
            return pushResonse.description == "Success"
        } catch {
            throw error
        }
    }

}
