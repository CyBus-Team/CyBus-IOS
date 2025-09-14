import StoreKit
import FactoryKit

struct SubscriptionUseCases: SubscriptionUseCasesProtocol {
    
    @Injected(\.subscriptionRepository) var repository: SubscriptionRepositoryProtocol
    
    private let ids = [
        "6751908456", // Plus early
        "6751911811" // Plus monthly
    ]
    
    func fetchProducts() async throws -> [SubscriptionProductEntity] {
        let dtos = try await repository.fetchProducts(for: ids)
        return dtos.map { SubscriptionProductEntity.fromDTO($0) }
    }
}
