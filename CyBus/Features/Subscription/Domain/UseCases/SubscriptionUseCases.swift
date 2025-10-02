import StoreKit
import FactoryKit

actor SubscriptionUseCases: SubscriptionUseCasesProtocol {
    
    @Injected(\.subscriptionRepository) var repository: SubscriptionRepositoryProtocol
    
    private let ids = [
        "cybus.pro.yearly", // "6751908456"
        "cybus.pro.monthly" // "6751911811"
    ]
    
    func subscribe(product: SubscriptionProductEntity) async throws -> PurchaseStatus {
        do {
            let result = try await repository.subscribe(for: product.id)
            return switch (result) {
            case .success(_):
                    .success
            case .userCancelled:
                    .cancelled
            case .pending:
                    .pending
            @unknown default:
                    .failed
            }
        } catch {
            throw error
        }
    }
    
    func fetchProducts() async throws -> [SubscriptionProductEntity] {
        do {
            let dtos = try await repository.fetchProducts(for: ids)
            return dtos.map { SubscriptionProductEntity.fromDTO($0) }
        } catch {
            throw error
        }
    }
}
