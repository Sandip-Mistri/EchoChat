//
//  UITableView+Extension.swift
//  EchoChat
//
//  Created by Sandip on 18/06/25.
//

import Foundation
import UIKit

protocol NibProvidable {
    static var nibName: String { get }
    static var nib: UINib { get }
}

extension NibProvidable {
    static var nibName: String {
        return "\(self)"
    }
    static var nib: UINib {
        return UINib(nibName: self.nibName, bundle: nil)
    }
}

protocol ReusableView {
    static var reuseIdentifier: String { get }
}

extension ReusableView {
    static var reuseIdentifier: String {
        return "\(self)"
    }
}

// Cell

extension UITableView {
    
    func registerClass<T: UITableViewCell>(cellClass: T.Type) where T: ReusableView {
        register(cellClass, forCellReuseIdentifier: cellClass.reuseIdentifier)
    }
    
    func registerNib<T: UITableViewCell>(_ cellClass: T.Type) where T: NibProvidable & ReusableView {
        register(cellClass.nib, forCellReuseIdentifier: cellClass.reuseIdentifier)
    }
    
    func dequeue<T: UITableViewCell>(_ cell: T.Type, for indexPath: IndexPath) -> T where T: ReusableView {
        guard let cell = self.dequeueReusableCell(withIdentifier: cell.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Error: cell with identifier: \(cell.reuseIdentifier) for index path: \(indexPath) is not \(T.self)")
        }
        return cell
    }
    
    func registerHeaderFooter<T: UITableViewHeaderFooterView>(_ viewClass: T.Type) where T: NibProvidable {
        self.register(viewClass.nib, forHeaderFooterViewReuseIdentifier: viewClass.nibName)
    }
    
    func dequeueHeader<T: UITableViewHeaderFooterView>(_ view : T.Type) -> T where T: ReusableView {
        guard let view = self.dequeueReusableHeaderFooterView(withIdentifier: view.reuseIdentifier) as? T else {
            fatalError("Error: cell with identifier: \(view.reuseIdentifier) is not \(T.self)")
        }
        return view
    }
}

extension UITableView {
    
    func startLoading() {
        if self.tableFooterView == nil {
            var activityIndicatorView = UIActivityIndicatorView()
            let indicatorFrame = CGRect(x: 0, y: 0, width: self.bounds.width, height: 50)
            activityIndicatorView = UIActivityIndicatorView(frame: indicatorFrame)
            activityIndicatorView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]
            activityIndicatorView.style = .medium
            activityIndicatorView.color = .white
            activityIndicatorView.hidesWhenStopped = true
            activityIndicatorView.isHidden = false
            activityIndicatorView.startAnimating()
            self.tableFooterView = activityIndicatorView
        }
    }
    func stopLoading() {
        self.tableFooterView = nil
    }
}
