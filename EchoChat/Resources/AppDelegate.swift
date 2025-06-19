//
//  AppDelegate.swift
//  EchoChat
//
//  Created by Sandip on 18/06/25.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        setRootViewController()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

extension AppDelegate {
    private func setRootViewController() {
        // VIPER Module
        let cardVC = CardRouter.createModule()
        let bornFireVC = BornFireRouter.createModule()
        let matchesVC = MatchesRouter.createModule()
        let chatListVC = ChatListRouter.createModule()
        
        // Use your custom navigation controller
        let cardNavController = NavigationController(rootViewController: cardVC)
        let bornFireNavController = NavigationController(rootViewController: bornFireVC)
        let matchesNavController = NavigationController(rootViewController: matchesVC)
        let chatNavController = NavigationController(rootViewController: chatListVC)

        // Use your custom tab bar controller
        let tabBarController = AppTabbarController()
        
        tabBarController.viewControllers = [cardNavController, bornFireNavController, matchesNavController, chatNavController]
        
        // Set rootViewController
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }
}
