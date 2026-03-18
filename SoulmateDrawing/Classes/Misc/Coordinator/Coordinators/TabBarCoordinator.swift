//
//  TabBarCoordinator.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 19.03.2026.
//

import Foundation
import UIKit

enum Tabs: Int {
    case home
    case dreamer
    case bonds
}

@MainActor
final class TabBarCoordinator: CoordinatorProtocol {
    var childCoordinator: [CoordinatorProtocol] = []
    
    private let tabBarController = UITabBarController()
    
    func switchTab(_ tab: Tabs) {
        tabBarController.selectedIndex = tab.rawValue
    }
    
    func start() -> UITabBarController {
        tabBarController.tabBar.tintColor = .textMain200
        tabBarController.tabBar.unselectedItemTintColor = .textMain200.withAlphaComponent(0.4)
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
        appearance.backgroundImage = nil
        appearance.shadowImage = nil
        appearance.shadowColor = nil
        
        tabBarController.tabBar.standardAppearance = appearance
                
        
        let homeController = UINavigationController()
        let homeCoordinator = HomeCoordinator(navigationController: homeController, tabBarCoordinator: self)
        homeController.tabBarItem = UITabBarItem(title: "Home".localized, image: UIImage(named: "home"), tag: 0)
        
        let dreamerController = UINavigationController()
        let dreamerCoordinator = DreamerCoordinator(navigationController: dreamerController)
        dreamerController.tabBarItem = UITabBarItem(title: "Dreamer".localized, image: UIImage(named: "dreamer"), tag: 1)
        
        let bondsController = UINavigationController()
        let bondsCoordinator = BondsCoordinator(navigationController: bondsController)
        bondsController.tabBarItem = UITabBarItem(title: "Bonds".localized, image: UIImage(named: "bonds"), tag: 2)
        
        childCoordinator = [homeCoordinator, dreamerCoordinator, bondsCoordinator]
        tabBarController.viewControllers = [homeController, dreamerController, bondsController]
        
        homeCoordinator.start()
        dreamerCoordinator.start()
        bondsCoordinator.start()
        
        return tabBarController
    }
}
