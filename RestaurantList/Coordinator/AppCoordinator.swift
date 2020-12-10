//
//  AppCoordinator.swift
//  RestaurantList
//
//  Created by Le, Triet on 9.12.2020.
//

import UIKit

class AppCoordinator {

    // MARK: - Private properties
    private var rootCoordinator: RootCoordinator?
    private var window: UIWindow

    // MARK: - Init
    init(window: UIWindow) {
        self.window = window
    }

    // MARK: - Private methods
    private func showRoot() {
        rootCoordinator = RootCoordinator(window: window)
        rootCoordinator?.start()
    }

}

// MARK: - Coordinator
extension AppCoordinator: Coordinator {
    func start() {
        // From here we can decide to show user correct flow - e.g Login Flow, Onboarding Flow or Main Flow
        showRoot()
    }
}
