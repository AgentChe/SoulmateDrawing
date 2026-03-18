//
//  DreamerCoordinator.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 19.03.2026.
//

import Foundation
import UIKit
import SwiftUI

final class DreamerCoordinator: CoordinatorBaseProtocol {
    weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    var childCoordinator: [CoordinatorProtocol] = []
    
    func start() {
        let viewModel = DreamerMainViewModel(coordinator: self)
        let view = DreamerMainScreen(viewModel: viewModel)
        let controller = UIHostingController(rootView: view)
        
        navigationController?.viewControllers = [controller]
    }
    
    func showHistory() {
        let viewModel = DreamHistoryViewModel(coordinator: self)
        let view = DreamerHistoryScreenView(viewModel: viewModel)
        let controller = UIHostingController(rootView: view)
        controller.hidesBottomBarWhenPushed = true
        controller.navigationItem.hidesBackButton = true
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func showDetails(using type: DreamerDetailsType) {
        let viewModel = DreamerDetailsViewModel(coordinator: self, type: type)
        let view = DreamerDetailsScreenView(viewModel: viewModel)
        let controller = UIHostingController(rootView: view)
        controller.hidesBottomBarWhenPushed = true
        controller.navigationItem.hidesBackButton = true
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func shareDream(text: String) {
        let item = ActivitySourceItem(item: text, title: "Share.Title".localized, icon: nil)
        let controller = UIActivityViewController(activityItems: [item], applicationActivities: nil)
        
        navigationController?.present(controller, animated: true)
    }
    
    func pop() {
        navigationController?.popViewController(animated: true)
    }
}
