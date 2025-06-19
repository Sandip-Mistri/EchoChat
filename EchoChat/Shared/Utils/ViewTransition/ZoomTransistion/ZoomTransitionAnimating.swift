import UIKit

public protocol ZoomTransitionAnimating: class {
    var transitionSourceImageView: UIImageView { get }
    var transitionSourceBackgroundColor: UIColor? { get }
    var transitionDestinationImageViewFrame: CGRect { get }
}
