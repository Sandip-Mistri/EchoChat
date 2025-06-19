//
//  UIVIew+Extension.swift
//  EchoChat
//
//  Created by Sandip on 18/06/25.
//

import Foundation
import UIKit


extension UIView {
    
    @IBInspectable
    public var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable
    public var borderColor: UIColor? {
        set {
            layer.borderColor = newValue?.cgColor
        }
        get {
            if let borderColor = layer.borderColor {
                return UIColor(cgColor: borderColor)
            }
            return nil
        }
    }
    
    @IBInspectable fileprivate var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        } set {
            self.layer.cornerRadius = newValue
            self.layer.masksToBounds = true
        }
    }
    
    @IBInspectable fileprivate var isRounded: Bool {
        get {
            return layer.cornerRadius == min(bounds.width, bounds.height) / 2
        }
        set {
            if newValue {
                // Delay this to allow layout pass to complete
                DispatchQueue.main.async {
                    let radius = min(self.bounds.width, self.bounds.height) / 2
                    self.layer.cornerRadius = radius
                    self.layer.masksToBounds = true
                }
            }
        }
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func shadow(color: UIColor, shadowOffset: CGSize, shadowRadius: CGFloat, shadowOpacity: Float) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOpacity = shadowOpacity
    }
    
    func removeShadow() {
        
        self.layer.shadowColor = UIColor.clear.cgColor
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 0.0
        self.layer.shadowOpacity = 0.0
    }
    
    func applyGradientBackground(
        colors: [UIColor],
        startPoint: CGPoint = CGPoint(x: 0, y: 0),
        endPoint: CGPoint = CGPoint(
            x: 1,
            y: 0
        )
    ) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.frame = self.bounds
        self.layer.insertSublayer(gradientLayer, at: 0)
        self.clipsToBounds = true
    }
    
}

// Animation
extension UIView {
    // Slide up with alpha animation
        func slideUpWithAlpha(duration: TimeInterval = 0.5, distance: CGFloat = 200, finalAlpha: CGFloat = 1.0, initialAlpha: CGFloat = 0.0, completion: ((Bool) -> Void)? = nil) {
            
            // Initially, set the view off-screen (below) and with the initial alpha (faded out)
            self.transform = CGAffineTransform(translationX: 0, y: distance)
            self.alpha = initialAlpha
            
            // Animate slide up and fade in simultaneously
            UIView.animate(withDuration: duration, animations: {
                // Move to the original position and change alpha to final value
                self.transform = CGAffineTransform.identity
                self.alpha = finalAlpha
            }, completion: completion)
        }
        
        // Slide down with alpha animation (optional, reverse of slide up)
        func slideDownWithAlpha(duration: TimeInterval = 0.5, distance: CGFloat = 200, finalAlpha: CGFloat = 1.0, initialAlpha: CGFloat = 0.0, completion: ((Bool) -> Void)? = nil) {
            
            // Initially, set the view off-screen (above) and with the initial alpha (fully visible)
            self.transform = CGAffineTransform(translationX: 0, y: -distance)
            self.alpha = initialAlpha
            
            // Animate slide down and fade out simultaneously
            UIView.animate(withDuration: duration, animations: {
                // Move to the original position and change alpha to final value
                self.transform = CGAffineTransform.identity
                self.alpha = finalAlpha
            }, completion: completion)
        }
}
