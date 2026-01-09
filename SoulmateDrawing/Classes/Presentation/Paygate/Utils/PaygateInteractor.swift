//
//  PaygateInteractor.swift
//  CodeChallenge
//
//  Created by Андрей Чернышев on 20.02.2024.
//

import Combine
import OtterScaleiOS

final class PaygateInteractor {
    enum Action {
        case buy(String)
        case restore
    }
    
    enum PurchaseActionResult {
        case cancelled
        case completed(Bool)
    }
    
    private lazy var iapManager = IAPManager()
    private lazy var sessionManager = SessionManager()
    private lazy var profileManager = ProfileManager()
    
    private var (stream, continuation) = AsyncStream<PurchaseActionResult>.makeStream()
    
    private var cancellable: AnyCancellable?
    
    var purchaseResult: AsyncStream<PurchaseActionResult> { stream }
    
    deinit {
        OtterScale.shared.removeReceiptValidation(delegate: self)
        
        continuation.finish()
    }
}

// MARK: Public
extension PaygateInteractor {
    func purchase(productId: String) async {
        OtterScale.shared.removeReceiptValidation(delegate: self)
        OtterScale.shared.addReceiptValidation(delegate: self)
        
        do {
            let result = try await iapManager.buyProduct(with: productId)
            guard case .cancelled = result else { return }
            
            continuation.yield(.cancelled)
        } catch {
            continuation.yield(.completed(false))
        }
        
    }
    
    func restore() async {
        OtterScale.shared.removeReceiptValidation(delegate: self)
        OtterScale.shared.addReceiptValidation(delegate: self)
        
        do {
            _ = try await iapManager.restorePurchases()
        } catch {
            continuation.yield(.completed(false))
        }
    }
}

// MARK: OtterScaleReceiptValidationDelegate
extension PaygateInteractor: OtterScaleReceiptValidationDelegate {
    func otterScaleDidValidatedReceipt(with result: AppStoreValidateResult?) {
        OtterScale.shared.removeReceiptValidation(delegate: self)
        
        let anonymousId = sessionManager.anonymousId
        let internalId = sessionManager.internalId
        
        Task {
            if anonymousId == internalId {
                try? await profileManager.create()
            } else {
                try? await profileManager.binding()
            }
            
            let hasActiveSubscriptions = sessionManager.hasActiveSubscriptions()
            continuation.yield(.completed(hasActiveSubscriptions))
        }
    }
}


//// MARK: Private
//private extension PaygateInteractor {
//    func purchase(productId: String) async {
//        do {
//            let result = try await iapManager.buyProduct(with: productId)
//            guard case .cancelled = result else { return }
//            
//            continuation.yield(.cancelled)
//        } catch {
//            continuation.yield(.completed(false))
//        }
//        
//    }
//    
//    func restore() async {
//        do {
//            _ = try await iapManager.restorePurchases()
//        } catch {
//            continuation.yield(.completed(false))
//        }
//    }
//}
