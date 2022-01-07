//
//  Coordinator.swift
//  SwiftUI-MVVM-Coordinator-Test
//
//  Created by Максим Чесников on 04.01.2022.
//

import UIKit
import Combine

protocol CoordinatorProtocol: AnyObject, CoordinatorNavigationControllerDelegate {
    
    var cancellables: [String: AnyCancellable] { get set }
    
    var window: UIWindow? { get set }
    
    var parent: CoordinatorProtocol? { get set }
    
    var child: [CoordinatorProtocol] { get set }
    
    var navigationController: CoordinatorNavigationController! { get }
    
    func popScene(animated: Bool)
    func popToRootScene(animated: Bool)
    
    func removeScene()
    
    func getLastChild() -> CoordinatorProtocol?
}

extension CoordinatorProtocol {
    
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
    }
    
    func transitionBackFinished() {
        if let lastChild = getLastChild() {
            lastChild.parent?.child.removeLast()
        } else {
            child.removeLast()
        }
    }
    
    func didSelectCustomBackAction() {}
    
    func getLastChild() -> CoordinatorProtocol? {
        var localChild: CoordinatorProtocol? = child.last
        while localChild?.child.last != nil {
            localChild = localChild?.child.last
        }
        return localChild
    }
    
}

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
