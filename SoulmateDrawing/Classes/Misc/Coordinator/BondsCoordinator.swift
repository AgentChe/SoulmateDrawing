//
//  BondsCoordinator.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 16.03.2026.
//

import Foundation
import UIKit
import SwiftUI

final class BondsCoordinator: CoordinatorBaseProtocol {
    weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    var childCoordinator: [CoordinatorProtocol] = []
    
    func start() {
        let viewModel = BondsViewModel(coordinator: self)
        let view = BondsView(viewModel: viewModel)
        let controller = UIHostingController(rootView: view)
        
        navigationController?.viewControllers = [controller]
    }
    
    func createPerson(createdPerson: @escaping (PersonModel) -> Void) {
        let coordinator = NewPersonCoordinator(parent: self, createdPerson: createdPerson)
        childCoordinator.append(coordinator)
        
        let controller = coordinator.start()
        
        if let sheet = controller.sheetPresentationController {
            sheet.preferredCornerRadius = 32.scale
            sheet.prefersGrabberVisible = true
        }
        
        if navigationController?.presentedViewController != nil {
            navigationController?.dismiss(animated: true)
        }
        navigationController?.present(controller, animated: true)
    }
    
    func openPersonList(persons: [PersonModel], didSelected: @escaping (PersonModel) -> Void) {
        let viewModel = PersonListViewModel(coordinator: self, persons: persons) { [weak self] in
            didSelected($0)
            self?.navigationController?.dismiss(animated: true)
        }
        let view = PersonList(viewModel: viewModel)
        let controller = UIHostingController(rootView: view)
        
        if let sheet = controller.sheetPresentationController {
            sheet.preferredCornerRadius = 32.scale
            sheet.prefersGrabberVisible = true
        }
        
        navigationController?.present(controller, animated: true)
    }
    
    func openChat(using model: ChatModel) {
        let viewModel = ChatScreenViewModel(model: model, coordinator: self)
        let view = ChatViewScreen(viewModel: viewModel)
        let controller = UIHostingController(rootView: view)
        controller.hidesBottomBarWhenPushed = true
        controller.navigationItem.hidesBackButton = true
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func insigtsList() {
        let viewModel = InsightsListViewModel(coordinator: self)
        let view = InsightsListView(viewModel: viewModel)
        let controller = UIHostingController(rootView: view)
        controller.hidesBottomBarWhenPushed = true
        controller.navigationItem.hidesBackButton = true
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func connectionType(selected: @escaping (ConnectionType) -> Void) {
        let view = ConnectionTypeView { [weak self] in
            selected($0)
            self?.navigationController?.dismiss(animated: true)
        }
        let controller = UIHostingController(rootView: view)
        
        if let sheet = controller.sheetPresentationController {
            sheet.preferredCornerRadius = 32.scale
            sheet.prefersGrabberVisible = true
        }
        
        controller.sizingOptions = .intrinsicContentSize
        navigationController?.present(controller, animated: true)
    }
    
    func showDeleteAlert(action: @escaping () -> Void) {
        let controller = UIAlertController(
            title: "Chat.DeleteTitle".localized,
            message: "Chat.DeleteMessage".localized,
            preferredStyle: .alert
        )
        
        let deleteAction = UIAlertAction(title: "Chat.Delete".localized, style: .destructive) { _ in
            action()
        }
        
        let cancelAction = UIAlertAction(title: "Chat.Cancel".localized, style: .cancel)
        
        controller.addAction(deleteAction)
        controller.addAction(cancelAction)
        
        navigationController?.present(controller, animated: true)
    }
}
