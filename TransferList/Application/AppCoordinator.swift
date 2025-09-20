//
//  AppCoordinator.swift
//  TransferList
//
//  Created by Yaser Bahrami on 19.09.2025.
//

import UIKit

final class AppCoordinator {
    private let window: UIWindow
    private let container: AppDIContainer
    private let nav = UINavigationController()

    init(window: UIWindow, container: AppDIContainer) {
        self.window = window
        self.container = container
    }

    func start() {
        let home = container.makeHome()
        if let homeVC = home as? HomeViewController {
            homeVC.onOpenDetails = { [weak self] t in
                guard let self else { return }
                self.nav.pushViewController(self.container.makeDetails(for: t), animated: true)
            }
        }
        nav.setViewControllers([home], animated: false)
        nav.view.backgroundColor = .systemBackground
        window.rootViewController = nav
        window.makeKeyAndVisible()
    }
}
