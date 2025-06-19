//
//  NavigationController.swift
//  EchoChat
//
//  Created by Sandip on 18/06/25.
//

import UIKit

class NavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
}

extension NavigationController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let sourceTransition = fromVC as? ZoomTransitionAnimating,
              let destinationTransition = toVC as? ZoomTransitionable else {
            return nil
        }
        
        let animator = ZoomTransitionAnimator()
        animator.goingForward = (operation == .push)
        animator.sourceTransition = sourceTransition
        animator.destinationTransition = destinationTransition
        return animator;
    }
}

