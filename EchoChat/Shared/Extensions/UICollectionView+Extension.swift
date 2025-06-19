//
//  UICollectionView+Extension.swift
//  EchoChat
//
//  Created by Sandip on 18/06/25.
//

import Foundation
import UIKit

extension UICollectionView {

    func reloadWithAnimations(withDuration: Double = 0.5) {
        UIView.transition(with: self, duration: withDuration,
                          options: [.transitionCrossDissolve, .allowUserInteraction],
                          animations: {
            self.reloadData()
        })
    }
    
    func reloadWithAnimations(withDuration: Double = 0.5, indexPath: IndexPath) {
        UIView.transition(with: self, duration: withDuration,
                          options: [.transitionCrossDissolve, .allowUserInteraction],
                          animations: {
            self.reloadItems(at: [indexPath])
        })
    }
    
    func registerClass<T: UICollectionViewCell>(cellClass: T.Type) where T: ReusableView {
        register(cellClass, forCellWithReuseIdentifier: cellClass.reuseIdentifier)
    }
    
    func registerNib<T: UICollectionViewCell>(_ cellClass: T.Type) where T: NibProvidable & ReusableView {
        register(cellClass.nib, forCellWithReuseIdentifier: cellClass.reuseIdentifier)
    }
    
    func dequeueCell<T: UICollectionViewCell>(cellClass: T.Type, forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as? T else {
            fatalError("Unable to Dequeue Reusable CollectionView Cell")
        }
        return cell
    }

    func dequeueReusableView<T: UICollectionReusableView>(ofKind elementKind: String,
                                                          viewType: T.Type,
                                                          for indexPath: IndexPath) -> T {
        guard let view = dequeueReusableSupplementaryView(ofKind: elementKind,
                                                          withReuseIdentifier: T.identifier,
                                                          for: indexPath) as? T else {
            fatalError("Unable to Dequeue Collection ReusableView")
        }
        return view
    }
}

extension UICollectionReusableView {

    static var identifier: String {
        return String(describing: self)
    }
}
