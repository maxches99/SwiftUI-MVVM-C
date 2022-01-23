//
//  Coordinator.swift
//  SwiftUI-MVVM-Coordinator-Test
//
//  Created by Максим Чесников on 04.01.2022.
//

import UIKit
import Combine

class Coordinator: CoordinatorNavigationControllerDelegate {
    
    var cancellables: [String: AnyCancellable] = [:]
    
    var window: UIWindow? = nil
    
    unowned var parent: Coordinator? = nil
    
    var child: [Coordinator] = []
    
    init(parent: Coordinator?) {
        self.parent = parent
    }
}

extension Coordinator {
    
    var navigationController: CoordinatorNavigationController! {
        guard let nc = window?.rootViewController as? CoordinatorNavigationController else { return parent?.navigationController }
        nc.swipeBackDelegate = self
        return nc
    }
    
    func popScene(animated: Bool) {
        navigationController.popViewController(animated: animated)
        parent?.child.removeLast()
    }
    
    func popToRootScene(animated: Bool) {
        navigationController.popToRootViewController(animated: animated)
        var localParent: Coordinator? = parent
        if let localParent = localParent {
            localParent.child.removeAll()
        }
        while localParent != nil {
            if let localParent = localParent {
                localParent.child.removeAll()
            }
            localParent = localParent?.parent
        }
    }
    
    func removeScene() {
        parent?.child.removeLast()
    }
    
    func transitionBackFinished() {
        if let lastChild = getLastChild() {
            lastChild.parent?.child.removeLast()
        } else {
            child.removeLast()
        }
    }
    
    func didSelectCustomBackAction() {}
    
    func getLastChild() -> Coordinator? {
        var localChild: Coordinator? = child.last
        while localChild?.child.last != nil {
            localChild = localChild?.child.last
        }
        return localChild
    }
    
    func pushScene(viewController: UIViewController, coordinator: Coordinator, animated: Bool) {
        child.append(coordinator)
        navigationController.pushViewController(viewController, animated: animated)
    }
    
    func changeRootScene(viewController: UIViewController, coordinator: Coordinator) {
        coordinator.window = window
        child.append(coordinator)
        let nav = CoordinatorNavigationController(rootViewController: viewController)
        
        nav.navigationBar.isHidden = true
        window?.rootViewController = nav
    }
    
}
