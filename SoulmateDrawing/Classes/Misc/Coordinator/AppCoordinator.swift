//
//  AppCoordinator.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 16.03.2026.
//

import Foundation
import Combine
import UIKit

enum Flow {
    case splash
    case onboarding
    case main
}

final class AppCoordinator: CoordinatorProtocol {
    var childCoordinator: [CoordinatorProtocol] = []
    
    private let switchFlow = PassthroughSubject<Flow, Never>()
    private var cancellable = Set<AnyCancellable>()
    
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
        build()
    }
    
    private func build() {
        switchFlow
            .subscribe(on: DispatchQueue.main)
            .sink { [weak self] flow in
                switch flow {
                case .splash:
                    self?.childCoordinator.removeAll()
                    self?.startSplash()
                case .onboarding:
                    self?.childCoordinator.removeAll()
                    self?.startOnboarding()
                case .main:
                    self?.childCoordinator.removeAll()
                    self?.startMain()
                }
            }
            .store(in: &cancellable)
    }
    
    func start() {
        startSplash()
    }
}

extension AppCoordinator {
    private func startSplash() {
        let navigationController = UINavigationController()
        let coordinator = SplashCoordinator(switchFlow: switchFlow, navigationController: navigationController)
        childCoordinator.append(coordinator)
        
        coordinator.start()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    private func startOnboarding() {
        let navigationController = UINavigationController()
        let coordinator = OnboardinCoordinator(switchFlow: switchFlow, navigationController: navigationController)
        
        childCoordinator.append(coordinator)
        coordinator.start()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    private func startMain() {
        let coordinator = TabBarCoordinator()
        childCoordinator.append(coordinator)
        
        window.rootViewController = coordinator.start()
        window.makeKeyAndVisible()
    }
}
