//
//  RootCoordinator.swift
//  RestaurantList
//
//  Created by Le, Triet on 9.12.2020.
//

import UIKit

class RootCoordinator {

    // MARK: - Private properties
    private let window: UIWindow
    private let navigationController: UINavigationController

    // MARK: - Init
    init(window: UIWindow) {
        self.window = window

        navigationController = UINavigationController()
        navigationController.navigationBar.isTranslucent = true
        navigationController.setNavigationBarHidden(true, animated: false)
    }

}

// MARK: - Coordinator
extension RootCoordinator: Coordinator {
    func start() {
        let networkManager = NetworkManager(baseUrlString: AppPantry.baseUrlString)
        let viewModel = RootViewModel(networkManager: networkManager)
        let rootViewController = RootViewController(viewModel: viewModel)

        navigationController.setViewControllers([rootViewController], animated: false)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
