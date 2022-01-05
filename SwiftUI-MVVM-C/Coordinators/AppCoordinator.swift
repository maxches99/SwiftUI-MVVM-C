//
//  AppCoordinator.swift
//  SwiftUI-MVVM-Coordinator-Test
//
//  Created by Максим Чесников on 04.01.2022.
//

import UIKit
import SwiftUI
import Combine

enum HomeTab {
    case meat
    case veggie
    case settings
}

protocol AppCoordinatorProtocol: CoordinatorProtocol {
    func start()
}

class AppCoordinator: AppCoordinatorProtocol {
    
    var window: UIWindow?
    
    var cancellables = [String: AnyCancellable]()
    
    var child: [CoordinatorProtocol] = []
    
    unowned var parent: CoordinatorProtocol?
    
    init(window: UIWindow, parent: AppCoordinator?) {
        self.window = window
        self.parent = parent
    }
    
    init(parent: AppCoordinator?) {
        self.parent = parent
        self.window = nil
    }
    
    func start() {
        showLaunchScreen()

        DispatchQueue.main.async { [weak self] in
            self?.showListScreen()
        }
    }
    
    private func showLaunchScreen() {
        let storyboard = UIStoryboard(name: "LaunchScreen", bundle: nil)
        guard let viewController = storyboard.instantiateInitialViewController() else {
            fatalError("Could not instantiate initial view controller from storyboard")
        }
        window?.rootViewController = viewController
    }
    
    private func showListScreen() {
        let service = WeatherServiceImpl()
        let viewModel = WeatherListViewModel(service: service)
        viewModel.getForecasts()
        let weatherListCoordinator = WeatherListCoordinator(viewModel: viewModel, parent: nil)
        weatherListCoordinator.window = window
        child.append(weatherListCoordinator)


        let controller = UIHostingController(rootView: weatherListCoordinator.view.environmentObject(viewModel))
        let nav = UINavigationController(rootViewController: controller)
        nav.navigationBar.isHidden = true
        window?.rootViewController = nav
    }
    
}
