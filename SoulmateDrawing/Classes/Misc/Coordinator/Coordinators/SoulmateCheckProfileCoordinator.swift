//
//  SoulmateCheckProfileCoordinator.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 19.03.2026.
//

import Foundation
import UIKit
import SwiftUI

final class SoulmateCheckProfileCoordinator: CoordinatorModalProtocol {
    
    private weak var navigationController: UINavigationController?
    private weak var parent: HomeCoordinator?
    var childCoordinator: [CoordinatorProtocol] = []
    
    init(parent: HomeCoordinator) {
        self.parent = parent
    }
    
    func start() -> UIViewController {
        let viewModel = SoulmateCheckProfileViewModel(coordinator: self)
        let view = SoulmateCheckProfileScreen(viewModel: viewModel)
        let controller = UIHostingController(rootView: view)
        
        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.modalPresentationStyle = .fullScreen
        self.navigationController = navigationController
        
        return navigationController
    }
    
    func openSettings() {
        let coordinator = SettingsCoordinator(parent: self)
        childCoordinator.append(coordinator)
        navigationController?.present(coordinator.start(), animated: true)
    }
    
    func showPreferences(elements: [String], selected: @escaping (String) -> Void) {
        let view = SoulmatePreferencesView(elements: elements, selected: selected)
        let controller = UIHostingController(rootView: view)
        
        navigationController?.present(controller, animated: true)
    }
    
    func dismiss() {
        navigationController?.dismiss(animated: true) { [weak self] in
            if self?.navigationController?.viewControllers.count == 1 {
                self?.parent?.childCoordinator.removeAll { $0 === self }
            }
        }
    }
    
    func openResult(model: SoulmateModel) {
        navigationController?.dismiss(animated: true) { [weak self] in
            self?.parent?.openSoulmate(model: model)
            self?.parent?.childCoordinator.removeAll { $0 === self }
        }
    }
}
