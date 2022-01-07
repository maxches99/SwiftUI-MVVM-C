//
//  WeatherListCoordinator.swift
//  SwiftUI-MVVM-Coordinator-Test
//
//  Created by Максим Чесников on 04.01.2022.
//

import SwiftUI
import Combine

class WeatherListCoordinator: CoordinatorProtocol, ObservableObject, Identifiable {
    var window: UIWindow?
    
    var parent: CoordinatorProtocol?
    
    var child: [CoordinatorProtocol] = []
    
    @Published var viewModel: WeatherListViewModel!
    
    var cancellables: [String: AnyCancellable] = [:]
    
    init(viewModel: WeatherListViewModel,
         parent: CoordinatorProtocol?) {
        
        print("||init WeatherListCoordinator")
        
        self.parent = parent
        
        self.viewModel = viewModel
        
        listenActions()
    }
    
    func listenActions() {
        cancellables["showList"] = viewModel.didSelectedIndividual
            .sink { [weak self] (item) in
                self?.showDetailScreen(item)
            }
    }
    
    private func showDetailScreen(_ item:Forecast) {
        print("||showDetailScreen(_ item:Forecast)")
        let viewModel = WeatherDetailViewModel(forecast: item)
        let weatherDetailCoordinator = WeatherDetailCoordinator(viewModel: viewModel, parent: self)
        let controller = UIHostingController(rootView: weatherDetailCoordinator.view.environmentObject(viewModel))
        
        pushScene(viewController: controller, coordinator: weatherDetailCoordinator, animated: true)
    }
}
