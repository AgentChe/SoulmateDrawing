//
//  OnboardinCoordinator.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 19.03.2026.
//

import Foundation
import UIKit
import SwiftUI
import Combine

final class OnboardinCoordinator: CoordinatorBaseProtocol {
    let switchFlow: PassthroughSubject<Flow, Never>
    weak var navigationController: UINavigationController?
    
    init(switchFlow: PassthroughSubject<Flow, Never>, navigationController: UINavigationController) {
        self.switchFlow = switchFlow
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = OnboardingViewModel(coordinator: self)
        let view = OnboardingView(viewModel: viewModel)
        let controller = UIHostingController(rootView: view)
        
        navigationController?.viewControllers = [controller]
    }
    
    func showMain() {
        switchFlow.send(.main)
    }
    
    var childCoordinator: [CoordinatorProtocol] = []
    
}
