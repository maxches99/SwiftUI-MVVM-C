//
//  WeatherDetailCoordinator.swift
//  SwiftUI-MVVM-C
//
//  Created by Максим Чесников on 04.01.2022.
//

import SwiftUI
import Combine

class WeatherDetailCoordinator: Coordinator, ObservableObject, Identifiable {
    
    @Published var viewModel:WeatherDetailViewModel!
    @Published var view: WeatherDetailView!
    
    init(viewModel: WeatherDetailViewModel,
         parent: Coordinator) {
        
        super.init(parent: parent)
        
        self.viewModel = viewModel
        self.view = WeatherDetailView()
        
        listenActions()
    }
    
    
    func listenActions() {
        cancellables["popVC"] = viewModel.didNavigateBack
            .sink { [weak self] (item) in
                self?.popScene(animated: true)
//                self?.navigationController.popViewController(animated: true)
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
    }
    
    private func showDetailScreen(_ item:Forecast) {
        let viewModel = WeatherDetailViewModel(forecast: item)
        let weatherDetailCoordinator = WeatherDetailCoordinator(viewModel: viewModel, parent: self)
        let controller = UIHostingController(rootView: weatherDetailCoordinator.view.environmentObject(viewModel))
        pushScene(viewController: controller, coordinator: weatherDetailCoordinator, animated: true)
    }
    
    deinit {
        print("||deinit WeatherDetailCoordinator")
    }
}

