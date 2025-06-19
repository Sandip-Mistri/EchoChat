//
//  ChatListRouter.swift
//  EchoChat
//
//  Created by Sandip on 18/06/25.
//

import Foundation
import UIKit

class ChatListRouter: ChatListPresenterToRouterProtocol{
    
    // MARK: - Methods
    class func createModule() -> UIViewController {
        
        let view = mainstoryboard.instantiateViewController(withIdentifier: "ChatScreenViewController") as! ChatScreenViewController
        let presenter: ChatListViewToPresenterProtocol & ChatListInteractorToPresenterProtocol = ChatListPresenter()
        let interactor: ChatListPresentorToInteractorProtocol = ChatCardsInteractor()
        let router: ChatListPresenterToRouterProtocol = ChatListRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        return view
    }
    
    static var mainstoryboard: UIStoryboard {
        return UIStoryboard(name:"Main",bundle: Bundle.main)
    }
}

