//
//  PaygateCoordinator.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 19.03.2026.
//

import Foundation
import UIKit
import SwiftUI

final class PaygateCoordinator: CoordinatorModalProtocol {
    private weak var parent: CoordinatorProtocol?
    private weak var navigationController: UINavigationController?
    
    init(parent: CoordinatorProtocol) {
        self.parent = parent
    }
    
    var childCoordinator: [CoordinatorProtocol] = []
    
    func start() -> UIViewController {
        let viewModel = PaygateViewModel(coordinator: self)
        let view = PaygateView(viewModel: viewModel)
        
        let controller = UIHostingController(rootView: view)
        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.modalPresentationStyle = .fullScreen
        
        self.navigationController = navigationController
        return navigationController
    }
    
    func dismiss() {
        navigationController?.dismiss(animated: true) { [weak self] in
            self?.cleanup()
        }
    }
    
    private func cleanup() {
        parent?.childCoordinator.removeAll { $0 === self }
    }
}
