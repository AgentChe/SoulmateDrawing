//
//  NewPersonCoordinator.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 19.03.2026.
//

import Foundation
import UIKit
import SwiftUI

final class NewPersonCoordinator: CoordinatorModalProtocol {
    var childCoordinator: [CoordinatorProtocol] = []
    
    private weak var parent: BondsCoordinator?
    private weak var navigationController: UINavigationController?
    private let createdPerson: (PersonModel) -> Void
    
    init(parent: BondsCoordinator, createdPerson: @escaping (PersonModel) -> Void) {
        self.createdPerson = createdPerson
        self.parent = parent
    }
    
    func start() -> UIViewController {
        let viewModel = NewPersonViewModel(coordinator: self)
        let view = NewPersonView(viewModel: viewModel)
        let controller = UIHostingController(rootView: view)
        let navigationController = UINavigationController(rootViewController: controller)
        self.navigationController = navigationController
        return navigationController
    }
    
    func showChangeDate(date: Date?, didTapContinue: @escaping (Date) -> Void) {
        let view = OnboardingBornDate(bornDate: date, didTapContinue: didTapContinue)
        let controller = UIHostingController(rootView: view)
        
        if let sheet = controller.sheetPresentationController {
            sheet.preferredCornerRadius = 32.scale
            sheet.prefersGrabberVisible = true
        }
        
        navigationController?.present(controller, animated: true)
    }
    
    func showChangeTime(date: Date?, didTapContinue: @escaping (Date) -> Void) {
        let view = OnboardingBornTime(bornTime: date, didTapContinue: didTapContinue)
        let controller = UIHostingController(rootView: view)
        
        if let sheet = controller.sheetPresentationController {
            sheet.preferredCornerRadius = 32.scale
            sheet.prefersGrabberVisible = true
        }
        
        navigationController?.present(controller, animated: true)
    }
    
    func showChangeCity(city: String, didTapContinue: @escaping (CityModel) -> Void) {
        let view = OnboardingCityView(city: city, didTapContinue: didTapContinue)
        let controller = UIHostingController(rootView: view)
        
        if let sheet = controller.sheetPresentationController {
            sheet.preferredCornerRadius = 32.scale
            sheet.prefersGrabberVisible = true
        }
        
        navigationController?.present(controller, animated: true)
    }
    
    func didCreatedPerson(person: PersonModel) {
        createdPerson(person)
        dismiss()
    }
    
    func dismiss() {
        navigationController?.dismiss(animated: true) { [weak self] in
            if self?.navigationController?.viewControllers.count == 1 {
                self?.cleanup()
            }
        }
    }
    
    private func cleanup() {
        parent?.childCoordinator.removeAll { $0 === self }
    }
}
