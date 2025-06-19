//
//  RecordingViewRouter.swift
//  EchoChat
//
//  Created by Sandip on 18/06/25.
//

import Foundation
import UIKit

class RecordingViewRouter: RecordingPresenterToRouterProtocol {
    
    weak var viewController: UIViewController?
    
    static func createModule(cardInfo: CardUsers, delegate: RecordingModuleDelegate?) -> UIViewController {
        let view = mainstoryboard.instantiateViewController(withIdentifier: "RecordingViewController") as! RecordingViewController
        let presenter: RecordingViewToPresenterProtocol & RecordingInteractorToPresenterProtocol = RecordingViewPresenter(cardInfo: cardInfo, delegate: delegate)
        let interactor: RecordingPresentorToInteractorProtocol = RecordingInteractor()
        let router: RecordingPresenterToRouterProtocol = RecordingViewRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        (router as! RecordingViewRouter).viewController = view
        
        return view
    }
    
    func navigateBackToChat() {
        if let viewController = viewController {
            viewController.navigationController?.popViewController(animated: true)
        }
    }
   
    static var mainstoryboard: UIStoryboard {
        return UIStoryboard(name:"Main",bundle: Bundle.main)
    }
}
