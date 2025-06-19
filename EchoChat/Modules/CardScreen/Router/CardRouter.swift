//
//  CardRouter.swift
//  EchoChat
//
//  Created by Sandip on 19/06/25.
//


import Foundation
import UIKit

class CardRouter {
    
    // MARK: - Methods
    
    class func createModule() -> UIViewController {
        
        let view = mainstoryboard.instantiateViewController(withIdentifier: "CardScreenViewController") as! CardScreenViewController
        
        return view
    }
    
    static var mainstoryboard: UIStoryboard {
        return UIStoryboard(name:"Main",bundle: Bundle.main)
    }
}
