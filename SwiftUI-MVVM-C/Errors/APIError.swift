//
//  APIError.swift
//  SwiftUI-MVVM-Coordinator-Test
//
//  Created by Максим Чесников on 04.01.2022.
//

import Foundation

enum APIError: Error {
    case decodingError
    case errorCode(Int)
    case searchingLocation
    case unknown
}

extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .decodingError:
            return "Мы не смогли понять какую хуйню вернул сервак"
        case .errorCode(let code):
            return "Код - \(code) - хуевый"
        case .unknown:
            return "Хуй знает почему все так хуево"
        case .searchingLocation:
            return "Пытаемся найти твою жопу мира"
        }
    }
}
