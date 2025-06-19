//
//  AppTabbarController.swift
//  EchoChat
//
//  Created by Mindinventory on 18/06/25.
//

import UIKit

class AppTabbarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabbarAttributes()
    }
    
    func configureTabbarAttributes() {
        let selectedColor   = UIColor.CFCFFE
        let unselectedColor = UIColor.white
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: unselectedColor,
                                                          NSAttributedString.Key.font: FontManager.shared.font(.regular, size: 10)], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: selectedColor,
                                                          NSAttributedString.Key.font: FontManager.shared.font(.bold, size: 10)], for: .selected)
        UITabBar.appearance().tintColor = UIColor.CFCFFE
        UITabBarItem.appearance().setBadgeTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
        UITabBarItem.appearance().setBadgeTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .selected)
    }

}


extension AppTabbarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController is NavigationController {
            return true
        }
        return false
    }
}
