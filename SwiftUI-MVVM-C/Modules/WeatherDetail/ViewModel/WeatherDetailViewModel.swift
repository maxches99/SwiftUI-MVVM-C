//
//  WeatherDetailViewModel.swift
//  SwiftUI-MVVM-C
//
//  Created by Максим Чесников on 04.01.2022.
//

import Foundation
import Combine
import protocol SwiftUI.ObservableObject

class WeatherDetailViewModel: ViewModel {
    
    let didSelectedIndividual = PassthroughSubject<Forecast, Never>()
    
    private(set) var forecast: Forecast
    
    init(forecast: Forecast) {
        self.forecast = forecast
    }
    
    func selectItem() {
        didSelectedIndividual.send(forecast)
    }
    
    deinit {
        print("||deinit WeatherDetailViewModel")
    }
    
}
