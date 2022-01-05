//
//  WeatherDetailCoordinator.swift
//  SwiftUI-MVVM-C
//
//  Created by Максим Чесников on 04.01.2022.
//

import SwiftUI
import Combine

class WeatherDetailCoordinator: CoordinatorProtocol, ObservableObject, Identifiable {
    var window: UIWindow?
    
    var parent: CoordinatorProtocol?
    
    @Published var viewModel:WeatherDetailViewModel!
    @Published var view: WeatherDetailView!
    
    var child: [CoordinatorProtocol] = []
    
    var cancellables: [String: AnyCancellable] = [:]
    
    init(viewModel: WeatherDetailViewModel,
         parent: CoordinatorProtocol) {
        
        self.parent = parent
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
        child.append(weatherDetailCoordinator)
        navigationController.pushViewController(controller, animated: true)
    }
    
    deinit {
        print("||deinit WeatherDetailCoordinator")
    }
}

