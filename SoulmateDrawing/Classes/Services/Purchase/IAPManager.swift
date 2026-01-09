//
//  IAPManager.swift
//  Soccer
//
//  Created by Андрей Чернышев on 03.02.2022.
//

import SwiftyStoreKit
import StoreKit
import Combine

final class IAPManager {}

// MARK: Public
extension IAPManager {
    static func initialize() {
        SwiftyStoreKit.completeTransactions { purchases in
            for purchase in purchases {
                let state = purchase.transaction.transactionState
                if state == .purchased || state == .restored {
                    SwiftyStoreKit.finishTransaction(purchase.transaction)
                }
            }
        }
        
        SwiftyStoreKit.shouldAddStorePaymentHandler = { _, _ in
            true
        }
    }
    
    func obtainProducts(ids: [String]) async -> [IAPProduct] {
        await withCheckedContinuation { continuation in
            SwiftyStoreKit.retrieveProductsInfo(Set(ids)) { result in
                let products = result.retrievedProducts.map { IAPProduct(original: $0) }
                continuation.resume(returning: products)
            }
        }
    }
    
    func obtainPrices(for ids: [String]) async -> [ProductPrice] {
        await withCheckedContinuation { continuation in
            SwiftyStoreKit.retrieveProductsInfo(Set(ids)) { results in
                let prices = results.retrievedProducts.map { product -> ProductPrice in
                    ProductPrice(product: product)
                }
                
                continuation.resume(returning: prices)
            }
        }
    }
    
    func buyProduct(with id: String) async throws -> IAPActionResult {
        guard SwiftyStoreKit.canMakePayments else {
            throw IAPError(.paymentsDisabled)
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            SwiftyStoreKit.purchaseProduct(id, quantity: 1, atomically: true) { result in
                switch result {
                case .success(let purchase):
                    if purchase.productId == id {
                        continuation.resume(returning: .completed(id))
                    } else {
                        continuation.resume(returning: .cancelled)
                    }
                case .error(let error):
                    if IAPErrorHelper.treatErrorAsCancellation(error) {
                        continuation.resume(returning: .cancelled)
                    } else if IAPErrorHelper.treatErrorAsSuccess(error) {
                        continuation.resume(returning: .completed(id))
                    } else {
                        continuation.resume(throwing: IAPError(.paymentFailed, underlyingError: error))
                    }
                }
            }
        }
    }
    
    func restorePurchases() async throws {
        return try await withCheckedThrowingContinuation { continuation in
            SwiftyStoreKit.restorePurchases { result in
                if result.restoredPurchases.isEmpty {
                    continuation.resume(throwing: IAPError(.cannotRestorePurchases))
                } else {
                    continuation.resume()
                }
            }
        }
    }
}
