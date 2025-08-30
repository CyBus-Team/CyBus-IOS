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
    @Injected(\.rateUsLocalRepository) var localRepository: RateUsRepositoryProtocol
    @Injected(\.rateUsRemoteRepository) var remoteRepository: RateUsRepositoryProtocol
    @Injected(\.rateUsAppStoreRepository) var appStoreRepository: RateUsRepositoryProtocol
    
    static let positiveRate: [Int] = [4, 5]
    static let negativeRate: [Int] = [1, 2, 3]
    
    func submit(email: String?, rating: Int, message: String) async throws {
        do {
            let dto = ReviewDTO(email: email, rating: rating, message: message)
            if (RateUsUseCases.negativeRate.contains(dto.rating)) {
                try await remoteRepository.submit(review: dto)
            } else if (RateUsUseCases.positiveRate.contains(dto.rating)) {
                try await appStoreRepository.submit(review: dto)
            }
            try await localRepository.submit(review: dto)
        } catch {
            throw error
        }
    }
    
    func needToShow() -> Bool {
        !localRepository.hasShown()
    }

}
