//
//  FontManager.swift
//  EchoChat
//
//  Created by Sandip on 18/06/25.
//


import UIKit

class FontManager {
    
    static let shared = FontManager()
    private init() {}
    
    enum AppFontStyle: String {
        case bold = "ProximaNova-Bold"
        case regular = "ProximaNova-Regular"
        case italic = "ProximaNova-Italic"
    }
    
    func font(_ style: AppFontStyle, size: CGFloat) -> UIFont {
        let scaleFactor = scaleFactorForDevice()
        return UIFont(name: style.rawValue, size: size + scaleFactor) ?? UIFont.systemFont(ofSize: size + scaleFactor)
    }
    
    // Scale ratio for different iPhone models
    private func scaleFactorForDevice() -> CGFloat {
        let deviceModel = UIDevice.current.model
        let scale = UIScreen.main.scale
        
        // Adjust scale factor based on screen size
        switch deviceModel {
        case "iPhone":
            // Default 1x devices
            return scale
        case "iPhone 5", "iPhone 5s", "iPhone SE":
            // iPhone 5 series has a smaller screen with a scale of 2x
            return 1.8 * scale // Adjusted for screen size and scaling
        case "iPhone 6", "iPhone 6s", "iPhone 7", "iPhone 8":
            // iPhone 6-8 series have 2x Retina screens
            return 1.5 * scale
        case "iPhone 6 Plus", "iPhone 7 Plus", "iPhone 8 Plus":
            // iPhone Plus series have 3x Retina screens
            return 2.0 * scale
        case "iPhone X", "iPhone XS", "iPhone 11 Pro":
            // iPhone X series, XS series, and 11 Pro have 3x screens
            return 2.2 * scale
        case "iPhone XR", "iPhone 11":
            // iPhone XR and iPhone 11 have 2x screens
            return 2.0 * scale
        case "iPhone XS Max", "iPhone 11 Pro Max":
            // iPhone XS Max, 11 Pro Max have 3x screens
            return 2.5 * scale
        case "iPhone 12 Mini", "iPhone 13 Mini", "iPhone 14 Mini":
            // iPhone Mini series have 3x screens
            return 2.6 * scale
        case "iPhone 12", "iPhone 12 Pro", "iPhone 13", "iPhone 13 Pro", "iPhone 14", "iPhone 14 Pro":
            // iPhone 12, 13, 14, and their Pro versions have 3x screens
            return 2.5 * scale
        case "iPhone 12 Pro Max", "iPhone 13 Pro Max", "iPhone 14 Pro Max":
            // iPhone 12 Pro Max, 13 Pro Max, 14 Pro Max have 3x screens
            return 2.8 * scale
        case "iPhone SE (2nd generation)", "iPhone SE (3rd generation)":
            // iPhone SE (2nd and 3rd gen) are similar to iPhone 6-8 but have 2x screens
            return 1.7 * scale
        case "iPhone 15", "iPhone 15 Pro":
            // iPhone 15 and 15 Pro series have 3x screens
            return 2.7 * scale
        case "iPhone 15 Plus", "iPhone 15 Pro Max":
            // iPhone 15 Plus and 15 Pro Max have 3x screens
            return 3.0 * scale
        case "iPhone 16", "iPhone 16 Pro":
            // iPhone 16 and 16 Pro series with a similar screen scaling to iPhone 15 series
            return 2.8 * scale
        case "iPhone 16 Plus", "iPhone 16 Pro Max":
            // iPhone 16 Plus and 16 Pro Max
            return 3.1 * scale
        case "iPhone 17", "iPhone 17 Pro":
            // iPhone 17 and 17 Pro series
            return 3.2 * scale
        case "iPhone 17 Plus", "iPhone 17 Pro Max":
            // iPhone 17 Plus and 17 Pro Max
            return 3.3 * scale
        default:
            // Default to 1.0 if the device model isn't recognized
            return scale
        }
    }
    
}


//extension UIFont {
//    
//
//
//    func setUpAppropriateFont() -> UIFont? {
//        // Get the scale factor based on the device
//        let scaleFactor = scaleFactorForDevice()
//        
//        // Adjust the font size based on the scale factor
//        return UIFont(name: self.fontName, size: self.pointSize * scaleFactor)
//    }
//}

