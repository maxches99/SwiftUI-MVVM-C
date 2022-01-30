//
//  WeatherListCoordinator.swift
//  SwiftUI-MVVM-Coordinator-Test
//
//  Created by Максим Чесников on 04.01.2022.
//

import SwiftUI
import Combine

class WeatherListCoordinator: Coordinator, ObservableObject {
    
    @Published var viewModel: WeatherListViewModel!
    
    init(viewModel: WeatherListViewModel,
         parent: Coordinator?) {
        super.init(title: "ListScreen", parent: parent)
        
        self.viewModel = viewModel
        
        listenActions()
    }
    
    func listenActions() {
        cancellables["didSelectedIndividual"] = viewModel.didSelectedIndividual
            .sink { [weak self] (item) in
                self?.showDetailScreen(item)
            }
    }
    
    private func showDetailScreen(_ item:Forecast) {
        let viewModel = WeatherDetailViewModel(forecast: item)
        let weatherDetailCoordinator = WeatherDetailCoordinator(viewModel: viewModel, parent: self)
        let controller = UIHostingController(rootView: weatherDetailCoordinator.view.environmentObject(viewModel))
        controller.navigationController?.title = "DetailScreen"
        viewModel.coordinator = weatherDetailCoordinator
        weatherDetailCoordinator.vc = controller
        
        pushScene(viewController: controller, coordinator: weatherDetailCoordinator, animated: true)
    }
}
