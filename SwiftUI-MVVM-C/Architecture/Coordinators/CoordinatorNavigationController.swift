//
//  CoordinatorNavigationController.swift
//  SwiftUI-MVVM-Coordinator-Test
//
//  Created by Максим Чесников on 08.01.2022.
//

import UIKit
import Combine

protocol CoordinatorNavigationControllerDelegate {
    func transitionBackFinished()
    func didSelectCustomBackAction()
}

class CoordinatorNavigationController: UINavigationController {
    
    
    private var transition: UIViewControllerAnimatedTransitioning?
    private var shouldEnableSwipeBack = false
    fileprivate var duringPushAnimation = false
    
    // MARK: Delegates
    
    var swipeBackDelegate: CoordinatorNavigationControllerDelegate?
    
    // MARK: - Initialization
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.shouldEnableSwipeBack = true
            self.interactivePopGestureRecognizer?.isEnabled = true
            self.interactivePopGestureRecognizer?.delegate = self
    }
    
    
    
}

// MARK: - Extensions
// MARK: - UINavigationControllerDelegate
extension CoordinatorNavigationController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self.transition
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let coordinator = navigationController.topViewController?.transitionCoordinator {
            coordinator.notifyWhenInteractionChanges { (context) in
                if !context.isCancelled {
                    self.swipeBackDelegate?.transitionBackFinished()
                }
            }
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let swipeNavigationController = navigationController as? CoordinatorNavigationController else { return }
        
        swipeNavigationController.duringPushAnimation = false
    }
    
}

// MARK: - UIGestureRecognizerDelegate
extension CoordinatorNavigationController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard gestureRecognizer == self.interactivePopGestureRecognizer else {
            return true
        }
        
        return self.viewControllers.count > 1 && self.duringPushAnimation == false
    }
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}
