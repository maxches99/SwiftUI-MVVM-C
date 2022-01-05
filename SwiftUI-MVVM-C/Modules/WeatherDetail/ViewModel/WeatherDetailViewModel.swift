//
//  WeatherDetailViewModel.swift
//  SwiftUI-MVVM-C
//
//  Created by Максим Чесников on 04.01.2022.
//

import Combine
import protocol SwiftUI.ObservableObject

class WeatherDetailViewModel: ObservableObject {
    let didNavigateBack = PassthroughSubject<Void, Never>()
    let didNavigateRoot = PassthroughSubject<Void, Never>()
    let didRemoveScene = PassthroughSubject<Void, Never>()
    let didSelectedIndividual = PassthroughSubject<Forecast, Never>()
    
    private var coordinator: WeatherDetailCoordinator?
    
    private(set) var forecast: Forecast
    
    init(forecast: Forecast) {
        self.forecast = forecast
    }
    
    func backAction() {
        didNavigateBack.send(())
    }
    
    func selectItem() {
        didSelectedIndividual.send(forecast)
    }
    
    func rootAction() {
        didNavigateRoot.send(())
    }
    
    func dismissScene() {
        didRemoveScene.send(())
    }
    
    deinit {
        print("||deinit WeatherDetailViewModel")
    }
    
}
