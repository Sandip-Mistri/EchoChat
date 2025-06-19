//
//  CustomProgressRingView.swift
//  dynamicTableview
//
//  Created by Sandip on 27/09/24.
//

import UIKit

class RingProgressView: UIView {
    
    // Properties to customize the view
    var progress: CGFloat = 0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var lineWidth: CGFloat = 4
    var trackColor: UIColor =  UIColor(hex: "#7B7B7B")
    var isCompleted: Bool = true
    var gradientColors: [UIColor]? = [UIColor(hex: "#4F4CB1"), // 0%
                                      UIColor(hex: "#CFCFFE"), // 50%
                                      UIColor(hex: "#21204B")].reversed()// 75%] // Gradient colors for track
    var progressColor: UIColor = .blue
    
    // MARK: - Animation Properties
    private var displayLink: CADisplayLink?
    private var animationStartTime: CFTimeInterval = 0
    private var startProgress: CGFloat = 0
    private var targetProgress: CGFloat = 0
    private var animationDuration: CFTimeInterval = 0.5
    
    // Initializer methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .clear
    }
    
    func setProgress(_ newProgress: CGFloat, animated: Bool = true, duration: CFTimeInterval = 0.5) {
        if animated {
            animationStartTime = CACurrentMediaTime()
            startProgress = self.progress
            targetProgress = newProgress
            animationDuration = duration
            
            displayLink?.invalidate()
            displayLink = CADisplayLink(target: self, selector: #selector(updateProgress))
            displayLink?.add(to: .main, forMode: .common)
        } else {
            self.progress = newProgress
        }
    }
    
    @objc private func updateProgress() {
        let elapsed = CACurrentMediaTime() - animationStartTime
        let t = min(elapsed / animationDuration, 1.0)
        
        // Optional: ease-in-out effect (smoothstep)
        let easedT = t * t * (3 - 2 * t)
        
        self.progress = startProgress + (targetProgress - startProgress) * CGFloat(easedT)
        
        if t >= 1.0 {
            displayLink?.invalidate()
            displayLink = nil
        }
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }

        let radius = min(rect.width, rect.height) / 2 - lineWidth / 2
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let startAngle = -CGFloat.pi / 2
        let endAngle = startAngle + progress * 2 * .pi

        // 1. Draw plain track
        let trackPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        trackColor.setStroke()
        trackPath.lineWidth = lineWidth
        trackPath.lineCapStyle = .round
        trackPath.stroke()

        // 2. Create progress path
        let progressPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        progressPath.lineWidth = lineWidth
        progressPath.lineCapStyle = .round

        // 3. Clip to progress stroke path
        context.saveGState()
        context.addPath(progressPath.cgPath)
        context.setLineWidth(lineWidth)
        context.replacePathWithStrokedPath()
        context.clip()

        // 4. Draw gradient within clipped region
        if let gradientColors = gradientColors {
            let cgColors = gradientColors.map { $0.cgColor } as CFArray
            if let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: cgColors, locations: [0.0, 0.5, 0.75, 1.0]) {
                let startPoint = CGPoint(x: rect.minX, y: rect.midY)
                let endPoint = CGPoint(x: rect.maxX, y: rect.midY)
                context.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: [])
            }
        } else {
            progressColor.setStroke()
            progressPath.stroke()
        }

        context.restoreGState()
    }

}




extension UIColor {
    convenience init(hex: String) {
        var hexFormatted: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted.remove(at: hexFormatted.startIndex)
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
