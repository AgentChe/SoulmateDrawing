//
//  CoordinatorProtocol.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 15.03.2026.
//

import Foundation

import UIKit
import SwiftUI

protocol CoordinatorProtocol: AnyObject {
    var childCoordinator: [CoordinatorProtocol] { get set }
}

protocol CoordinatorBaseProtocol: CoordinatorProtocol {
    var navigationController: UINavigationController? { get set }
    func start()
}

protocol CoordinatorModalProtocol: CoordinatorProtocol {
    func start() -> UIViewController
}

final class SplashCoordinator: CoordinatorBaseProtocol {
    let switchFlow: PassthroughSubject<Flow, Never>
    var navigationController: UINavigationController?
    
    init(switchFlow: PassthroughSubject<Flow, Never>, navigationController: UINavigationController?) {
        self.switchFlow = switchFlow
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = RootViewModel(coordinator: self)
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
    
    var childCoordinator: [CoordinatorProtocol] = []
    
    
}

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
}

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
    
    func pop() {
        navigationController?.popViewController(animated: true)
    }
}

final class PaygateCoordinator: CoordinatorModalProtocol {
    private weak var parent: CoordinatorProtocol?
    private weak var navigationController: UINavigationController?
    
    init(parent: CoordinatorProtocol) {
        self.parent = parent
    }
    
    var childCoordinator: [CoordinatorProtocol] = []
    
    func start() -> UIViewController {
        let viewModel = PaygateViewModel(coordinator: self)
        let view = PaygateView(viewModel: viewModel)
        
        let controller = UIHostingController(rootView: view)
        let navigationController = UINavigationController(rootViewController: controller)
        
        self.navigationController = navigationController
        return navigationController
    }
    
    func dismiss() {
        navigationController?.dismiss(animated: true) { [weak self] in
            self?.cleanup()
        }
    }
    
    private func cleanup() {
        parent?.childCoordinator.removeAll { $0 === self }
    }
}

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

final class SoulmateCheckProfileCoordinator: CoordinatorModalProtocol {
    
    private weak var navigationController: UINavigationController?
    private weak var parent: HomeCoordinator?
    var childCoordinator: [CoordinatorProtocol] = []
    
    init(parent: HomeCoordinator) {
        self.parent = parent
    }
    
    func start() -> UIViewController {
        let viewModel = SoulmateCheckProfileViewModel(coordinator: self)
        let view = SoulmateCheckProfile(viewModel: viewModel)
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
    
    func dismiss() {
        navigationController?.dismiss(animated: true) { [weak self] in
            if self?.navigationController?.viewControllers.count == 1 {
                self?.parent?.childCoordinator.removeAll { $0 === self }
            }
        }
    }
}

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
