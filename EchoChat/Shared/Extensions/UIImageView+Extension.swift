//
//  UIImageView+Extension.swift
//  EchoChat
//
//  Created by Sandip on 19/06/25.
//

import UIKit

extension UIImageView {
    enum ImageTransitionType {
        case flipFromLeft
        case flipFromRight
        case crossDissolve
        case curlUp
        case curlDown
        
        var animationOption: UIView.AnimationOptions {
            switch self {
            case .flipFromLeft: return .transitionFlipFromLeft
            case .flipFromRight: return .transitionFlipFromRight
            case .crossDissolve: return .transitionCrossDissolve
            case .curlUp: return .transitionCurlUp
            case .curlDown: return .transitionCurlDown
            }
        }
    }

    func setImage(_ image: UIImage?, with transition: ImageTransitionType = .crossDissolve, duration: TimeInterval = 0.4) {
        UIView.transition(with: self, duration: duration, options: [transition.animationOption], animations: {
            self.image = image
            self.alpha = 1
        }, completion: nil)
    }
}


