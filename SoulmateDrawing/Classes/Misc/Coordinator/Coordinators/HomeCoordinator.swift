//
//  HomeCoordinator.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 19.03.2026.
//

import Foundation
import SwiftUI
import UIKit

@MainActor
final class HomeCoordinator: CoordinatorBaseProtocol {
    weak var navigationController: UINavigationController?
    private weak var tabBarCoordinator: TabBarCoordinator?
    
    init(navigationController: UINavigationController, tabBarCoordinator: TabBarCoordinator) {
        self.navigationController = navigationController
        self.tabBarCoordinator = tabBarCoordinator
    }
    
    var childCoordinator: [CoordinatorProtocol] = []
    
    func start() {
        let viewModel = HomeViewModel(coordinator: self)
        let view = HomeView(viewModel: viewModel)
        let controller = UIHostingController(rootView: view)
        
        navigationController?.viewControllers = [controller]
    }
    
    func showSettings() {
        let coordinator = SettingsCoordinator(parent: self)
        navigationController?.present(coordinator.start(), animated: true)
    }
    
    func openSoulmate(model: SoulmateModel) {
        let viewModel = SoulmateDrawingResultViewModel(coordinator: self, soulmate: model)
        let view = SoulmateDrawingResultView(viewModel: viewModel)
        let controller = UIHostingController(rootView: view)
        controller.hidesBottomBarWhenPushed = true
        controller.navigationItem.hidesBackButton = true
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func startOver() {
        openCheckProfile()
        navigationController?.popViewController(animated: false)
    }
    
    func openExploreCard(_ card: ExploreItem) {
        let view = ExploreCardDetailView(item: card)
        let controller = UIHostingController(rootView: view)
        controller.hidesBottomBarWhenPushed = true
        controller.navigationItem.hidesBackButton = true
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func openCheckProfile() {
        let coordinator = SoulmateCheckProfileCoordinator(parent: self)
        childCoordinator.append(coordinator)
        navigationController?.present(coordinator.start(), animated: true)
    }
    
    func openOnboarding() {
        let view = SoulmateOnboarding(
            didTapBegin: { [weak self] in
                self?.navigationController?.dismiss(animated: false)
                self?.openCheckProfile()
            },
            close: { [weak self] in
                self?.navigationController?.dismiss(animated: true)
            }
        )
        
        let controller = UIHostingController(rootView: view)
        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.modalPresentationStyle = .fullScreen
        
        self.navigationController?.present(navigationController, animated: true)
    }
    
    func showPaygate() {
        let coordinator = PaygateCoordinator(parent: self)
        
        childCoordinator.append(coordinator)
        
        navigationController?.present(coordinator.start(), animated: true)
    }
    
    func showDreamer() {
        tabBarCoordinator?.switchTab(.dreamer)
    }
    
    func showBonds() {
        tabBarCoordinator?.switchTab(.bonds)
    }
    
    func shareSoulmate(image: UIImage) {
        let item = ActivitySourceItem(item: image, title: "Share.Title".localized, icon: image)
        let controller = UIActivityViewController(activityItems: [item], applicationActivities: nil)
        
        navigationController?.present(controller, animated: true)
    }
}
