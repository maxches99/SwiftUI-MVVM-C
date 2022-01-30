//
//  WeatherDetailCoordinator.swift
//  SwiftUI-MVVM-C
//
//  Created by Максим Чесников on 04.01.2022.
//

import SwiftUI
import Combine
import Foundation

class WeatherDetailCoordinator: Coordinator, ObservableObject {
    
    @Published var viewModel:WeatherDetailViewModel!
    @Published var view: WeatherDetailView!
    
    init(viewModel: WeatherDetailViewModel,
         parent: Coordinator) {
        
        super.init(title: "DetailScreen", parent: parent)
        
        self.viewModel = viewModel
        self.view = WeatherDetailView()
        
        listenActions()
    }
    
    
    func listenActions() {
        cancellables["popVC"] = viewModel.didNavigateBack
            .sink { [weak self] (item) in
                self?.popScene(animated: true)
        }
        
        cancellables["showList"] = viewModel.didSelectedIndividual
            .sink { [weak self] (item) in
                self?.showDetailScreen(item)
        }
        
        cancellables["showRoot"] = viewModel.didNavigateRoot
            .sink { [weak self] (item) in
                self?.popToRootScene(animated: true)
        }
        
        cancellables["removeScene"] = viewModel.didRemoveScene
            .sink { [weak self] (item) in
                self?.removeScene()
        }
        
        cancellables["didNavigateTo"] = viewModel.didNavigateTo
            .sink { [weak self] (item) in
                var localC = self?.parent
                
                while localC != item {
                    localC = localC?.parent
                }
                if let localC = localC {
                    self?.popToScene(coordinator: localC, animated: true)
                } else {
                    print("Error")
                }
        }
    }
    
    private func showDetailScreen(_ item:Forecast) {
        let viewModel = WeatherDetailViewModel(forecast: item)
        let weatherDetailCoordinator = WeatherDetailCoordinator(viewModel: viewModel, parent: self)
        let controller = UIHostingController(rootView: weatherDetailCoordinator.view.environmentObject(viewModel))
        viewModel.coordinator = weatherDetailCoordinator
        weatherDetailCoordinator.vc = controller
        
        pushScene(viewController: controller, coordinator: weatherDetailCoordinator, animated: true)
    }
    
    
    deinit {
        print("||deinit WeatherDetailCoordinator")
    }
}

