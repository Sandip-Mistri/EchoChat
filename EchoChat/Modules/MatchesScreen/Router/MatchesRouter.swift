//
//  MatchesRouter.swift
//  EchoChat
//
//  Created by Sandip on 19/06/25.
//

import Foundation
import UIKit

class MatchesRouter {
    
    // MARK: - Methods
    
    class func createModule() -> UIViewController {
        
        let view = mainstoryboard.instantiateViewController(withIdentifier: "MatchesScreenViewController") as! MatchesScreenViewController
        
        return view
    }
    
    static var mainstoryboard: UIStoryboard {
        return UIStoryboard(name:"Main",bundle: Bundle.main)
    }
}
