//
//  SplashCoordinator.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 19.03.2026.
//

import Foundation
import UIKit
import Combine
import SwiftUI

final class SplashCoordinator: CoordinatorBaseProtocol {
    let switchFlow: PassthroughSubject<Flow, Never>
    var navigationController: UINavigationController?
    
    var childCoordinator: [CoordinatorProtocol] = []
    
    init(switchFlow: PassthroughSubject<Flow, Never>, navigationController: UINavigationController?) {
        self.switchFlow = switchFlow
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = SplashViewModel(coordinator: self)
        let view = SplashView(viewModel: viewModel)
        
        let controller = UIHostingController(rootView: view)
        
        navigationController?.viewControllers = [controller]
    }
    
    func showOnboarding() {
        switchFlow.send(.onboarding)
    }
    
    func showMain() {
        switchFlow.send(.main)
    }
}
