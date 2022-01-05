//
//  ForecastState.swift
//  SwiftUI-MVVM-Coordinator-Test
//
//  Created by Максим Чесников on 04.01.2022.
//

import Foundation

enum ResultState: Equatable {
    static func == (lhs: ResultState, rhs: ResultState) -> Bool {
        switch (lhs, rhs) {
        case (locating, locating):
            return true
        case (endLocating, endLocating):
            return true
        case (loading, loading):
            return true
        case (success(let contentl), success(let contentr)):
            return contentl == contentr
        case (failed(_), failed(_)):
            return true
        default:
            return false
        }
    }
    
    case locating
    case endLocating
    case loading
    case success(content: [Forecast])
    case failed(error: Error)
    
    var title: String {
        switch self {
        case .locating:
            return "Идет поиск твоей жопы"
        case .endLocating:
            return "Мы нашли тебя, загружаем данные, чтобы твое ебало не замерзло"
        case .loading:
            return "Мы нашли тебя, загружаем данные, чтобы твое ебало не замерзло"
        case .success(_):
            return "Погода загружена, а ты все еще с нами"
        case .failed(_):
            return "Сервак работает, как сука, швейцарские часы, но не сеголня"
        }
    }
}

