//
//  Coordinator.swift
//  SwiftUI-MVVM-Coordinator-Test
//
//  Created by Максим Чесников on 04.01.2022.
//

import UIKit
import Combine

protocol CoordinatorProtocol: AnyObject {
    
    var cancellables: [String: AnyCancellable] { get set }
    
    var window: UIWindow? { get set }
    
    var parent: CoordinatorProtocol? { get set }
    
    var child: [CoordinatorProtocol] { get set }
    
    var navigationController: UINavigationController! { get }
    
    func popScene(animated: Bool)
    func popToRootScene(animated: Bool)
    
    func removeScene()
}

extension CoordinatorProtocol {
    
    var navigationController: UINavigationController! {
        guard let nc = window?.rootViewController as? UINavigationController else { return parent?.navigationController }
        return nc
    }
    
    func popScene(animated: Bool) {
        navigationController.popViewController(animated: animated)
        parent?.child.removeLast()
    }
    
    func popToRootScene(animated: Bool) {
        navigationController.popToRootViewController(animated: animated)
        var localParent: CoordinatorProtocol? = parent
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
        print(parent?.child)
    }
}
