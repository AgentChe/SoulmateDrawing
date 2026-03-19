//
//  SettingsCoordinator.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 19.03.2026.
//

import Foundation
import UIKit
import SwiftUI

final class SettingsCoordinator: CoordinatorModalProtocol {
    private weak var navigationController: UINavigationController?
    weak var parent: CoordinatorProtocol?
    
    init(parent: CoordinatorProtocol) {
        self.parent = parent
    }
    
    var childCoordinator: [CoordinatorProtocol] = []
    
    func start() -> UIViewController {
        let viewModel = SettingsViewModel(coordinator: self)
        let view = SettingsView(viewModel: viewModel)
        
        let controller = UIHostingController(rootView: view)
        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.modalPresentationStyle = .fullScreen
        self.navigationController = navigationController
        
        return navigationController
    }
    
    func showChangeDate(date: Date?, didTapContinue: @escaping (Date) -> Void) {
        let view = ChooseBornDateView(bornDate: date, isOnboarding: false, didTapContinue: didTapContinue)
        let controller = UIHostingController(rootView: view)
        
        if let sheet = controller.sheetPresentationController {
            sheet.preferredCornerRadius = 32.scale
            sheet.prefersGrabberVisible = true
        }
        
        navigationController?.present(controller, animated: true)
    }
    
    func showChangeTime(date: Date?, didTapContinue: @escaping (Date) -> Void) {
        let view = ChooseBornTimeView(bornTime: date, isOnboarding: false, didTapContinue: didTapContinue)
        let controller = UIHostingController(rootView: view)
        
        if let sheet = controller.sheetPresentationController {
            sheet.preferredCornerRadius = 32.scale
            sheet.prefersGrabberVisible = true
        }
        
        navigationController?.present(controller, animated: true)
    }
    
    func showChangeCity(city: String, didTapContinue: @escaping (CityModel) -> Void) {
        let view = ChooseCityView(city: city, isOnboarding: false, didTapContinue: didTapContinue)
        let controller = UIHostingController(rootView: view)
        
        if let sheet = controller.sheetPresentationController {
            sheet.preferredCornerRadius = 32.scale
            sheet.prefersGrabberVisible = true
        }
        
        navigationController?.present(controller, animated: true)
    }
    
    func showPaygate() {
        let coordinator = PaygateCoordinator(parent: self)
        
        childCoordinator.append(coordinator)
        
        navigationController?.present(coordinator.start(), animated: true)
    }
    
    func open(url: URL) {
        guard UIApplication.shared.canOpenURL(url) else { return }
        
        UIApplication.shared.open(url)
    }
    
    func dismiss() {
        navigationController?.dismiss(animated: true) { [weak self] in
            if self?.navigationController?.viewControllers.count == 1 {
                self?.parent?.childCoordinator.removeAll { $0 === self }
            }
        }
    }
}
