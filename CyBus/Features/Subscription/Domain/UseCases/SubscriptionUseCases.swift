import StoreKit
import FactoryKit

actor SubscriptionUseCases: SubscriptionUseCasesProtocol {
    
    @Injected(\.subscriptionRepository) var repository: SubscriptionRepositoryProtocol
    
    private let ids = [
        "cybus.pro.yearly", // "6751908456"
        "cybus.pro.monthly" // "6751911811"
    ]
    
    func restore() async throws -> PurchaseStatus {
        do {
            let transactions = try await repository.restore()
            let now = Date()
            // Consider active if any transaction for our IDs is not revoked and not expired
            let isActive = transactions.contains { tx in
                ids.contains(tx.productID) &&
                tx.revocationDate == nil &&
                (tx.expirationDate == nil || (tx.expirationDate ?? now) > now)
            }
            return isActive ? .success : .failed
        } catch {
            throw error
        }
    }
    
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
