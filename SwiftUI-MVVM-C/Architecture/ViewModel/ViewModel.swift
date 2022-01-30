//
//  ViewModel.swift
//  SwiftUI-MVVM-Coordinator-Test
//
//  Created by Максим Чесников on 30.01.2022.
//

import Foundation
import Combine
import protocol SwiftUI.ObservableObject

class ViewModel: NSObject, ObservableObject {
    
    let didNavigateBack = PassthroughSubject<Void, Never>()
    let didNavigateRoot = PassthroughSubject<Void, Never>()
    let didNavigateTo = PassthroughSubject<Coordinator, Never>()
    
    let didRemoveScene = PassthroughSubject<Void, Never>()
    
    weak var coordinator: Coordinator?
    
    var title: String {
        coordinator?.title ?? ""
    }
    
    func backAction() {
        didNavigateBack.send(())
    }
    
    func rootAction() {
        didNavigateRoot.send(())
    }
    
    func dismissScene() {
        didRemoveScene.send(())
    }
    
    func navigateTo(coordinator: Coordinator) {
        didNavigateTo.send(coordinator)
    }
    
    func getAllCoordinators() -> [Coordinator] {
        return coordinator?.getAllParents() ?? []
    }
    
}
