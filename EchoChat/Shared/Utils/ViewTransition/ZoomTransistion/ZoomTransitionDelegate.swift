import UIKit

@objc public protocol ZoomTransitionDelegate: class {
    @objc optional func zoomTransitionAnimator(animator: ZoomTransitionAnimator,
                                               didCompleteTransition didComplete: Bool,
                                               animatingSourceImageView imageView: UIImageView)
}
