//
//  PaygateViewModel.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 05.01.2026.
//

import Foundation

@Observable
final class PaygateViewModel {
    typealias Products = (yearly: ProductPrice, weekly: ProductPrice)
    
    var isOnTrial: Bool = true
    
    var currentProduct: PaygateProduct {
        isOnTrial ? .trial : .yearly
    }
    
    @MainActor
    private(set) var isLoading: Bool = true
    @MainActor
    var isShowError: Bool = false
    @MainActor
    private(set) var products: Products? = nil
    
    @ObservationIgnored
    private lazy var iapManager = IAPManager()
    @ObservationIgnored
    private lazy var paygateInteractor = PaygateInteractor()
    let coordinator: PaygateCoordinator
    
    init(coordinator: PaygateCoordinator) {
        self.coordinator = coordinator
    }
    
    func load() async {
        observePurchaseResult()
        let products = await makeProducts()
        await MainActor.run {
            self.products = products
            isLoading = false
        }
    }
    
    func restore() {
        Task {
            await paygateInteractor.restore()
        }
    }
    
    func byProduct() {
        let productID: String?
        switch currentProduct {
        case .trial:
            productID = products?.weekly.id
        case .yearly:
            productID = products?.yearly.id
        }
        
        guard let productID else { return }
        
        Task {
            await MainActor.run {
                isLoading = true
            }
            
            await paygateInteractor.purchase(productId: productID)
        }
    }
    
    func close() {
        coordinator.dismiss()
    }
}

private extension PaygateViewModel {
    func makeProducts() async -> Products? {
        let prices = await iapManager.obtainPrices(for: [
            GlobalDefinitions.Paygate.yearly,
            GlobalDefinitions.Paygate.weekly
        ])
        
        guard
            let yearly = prices.first(where: { $0.id == GlobalDefinitions.Paygate.yearly }),
            let weekly = prices.first(where: { $0.id == GlobalDefinitions.Paygate.weekly })
        else {
            return nil
        }
        
        return (yearly, weekly)
    }
    
    func observePurchaseResult() {
        let purchaseResult = paygateInteractor.purchaseResult
            .map { result in
                switch result {
                case let .completed(response):
                    return response
                case .cancelled:
                    return false
                }
            }
        
        Task {
            for await result in purchaseResult {
                await MainActor.run {
                    isLoading = false
                    isShowError = !result
                }
            }
        }
    }
}
