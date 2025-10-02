import StoreKit
import FactoryKit

actor SubscriptionUseCases: SubscriptionUseCasesProtocol {
    
    @Injected(\.subscriptionRepository) var repository: SubscriptionRepositoryProtocol
    
    private let ids = [
        "cybus.pro.yearly", // "6751908456"
        "cybus.pro.monthly" // "6751911811"
    ]
    
    func fetchProducts() async throws -> [SubscriptionProductEntity] {
        do {
            let dtos = try await repository.fetchProducts(for: ids)
            return dtos.map { SubscriptionProductEntity.fromDTO($0) }
        } catch {
            throw error
        }
    }
}
