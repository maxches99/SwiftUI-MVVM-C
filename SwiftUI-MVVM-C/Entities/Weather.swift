//
//  Weather.swift
//  SwiftUI-MVVM-Coordinator-Test
//
//  Created by Максим Чесников on 04.01.2022.
//

import Foundation


import Foundation

// MARK: - WeatherResponse
struct WeatherResponse: Codable {
    let forecast: [Forecast]
}

// MARK: - Forecast
struct Forecast: Codable, Equatable, Identifiable, Hashable {
    let id = UUID()
    let name: String?
    var temperature: Int?
    let unit: Unit?
    let forecastDescription: String?

    enum CodingKeys: String, CodingKey {
        case name, temperature, unit
        case forecastDescription = "description"
    }
}

enum Unit: String, Codable {
    case f = "F"
}

extension Forecast {
    static var dummyData: Forecast {
        .init(name: "Morning", temperature: 75, unit: Unit(rawValue: "F")!, forecastDescription: "Sunny")
    }
}
