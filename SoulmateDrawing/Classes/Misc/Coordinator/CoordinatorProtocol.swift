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
