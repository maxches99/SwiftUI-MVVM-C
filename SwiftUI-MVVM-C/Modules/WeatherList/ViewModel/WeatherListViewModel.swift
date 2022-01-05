//
//  WeatherListViewModel.swift
//  SwiftUI-MVVM-Coordinator-Test
//
//  Created by Максим Чесников on 04.01.2022.
//

import Foundation
import protocol SwiftUI.ObservableObject
import Combine
import CoreGraphics
import CoreLocation

class WeatherListViewModel: NSObject, ObservableObject {
    
    let didSelectedIndividual = PassthroughSubject<Forecast, Never>()
    
    private var coordinator: WeatherListCoordinator?
    
    private let service: WeatherService
    
    private(set) var forecasts = [Forecast]()
    private var cancellables = Set<AnyCancellable>()
    
    private let locationManager = CLLocationManager()
    
    private var locationData: (CLLocationDegrees, CLLocationDegrees)?
    
    @Published private(set) var state: ResultState = .loading
    @Published var title: String?
    
    init(service: WeatherService) {
        self.service = service
        
        locationManager.requestWhenInUseAuthorization()
        
        super.init()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func selectItem(item: Forecast) {
        didSelectedIndividual.send(item)
    }
    
    func getForecasts() {
        
        state = .loading
        
        guard let latitude = locationData?.0, let longitude = locationData?.1 else {
            return
        }
        
        service
            .request(from: .getWeather(latitude, longitude))
            .sink { [weak self] res in
                guard let strongSelf = self else { return }
                switch res {
                case .finished:
                    strongSelf.state = .success(content: strongSelf.forecasts)
                case .failure(let error):
                    strongSelf.state = .failed(error: error)
                }
            } receiveValue: { [weak self] response in
                self?.forecasts = response.forecast
            }
            .store(in: &cancellables)
    }
}

extension WeatherListViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        locationData = (locValue.latitude, locValue.longitude)
        getForecasts()
    }
}


