//
//  AppCoordinator.swift
//  SwiftUI-MVVM-Coordinator-Test
//
//  Created by Максим Чесников on 04.01.2022.
//

import UIKit
import SwiftUI
import Combine

protocol AppCoordinatorProtocol {
    func start()
}

class AppCoordinator: Coordinator, AppCoordinatorProtocol {
    
    init(window: UIWindow, parent: Coordinator?) {
        super.init(title: "AppCoordinator", parent: parent)
        self.window = window
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
        let controller = UIHostingController(rootView: WeatherListView().environmentObject(viewModel))
        weatherListCoordinator.vc = controller
        viewModel.coordinator = weatherListCoordinator
        
        changeRootScene(viewController: controller, coordinator: weatherListCoordinator)
    }
    
}
