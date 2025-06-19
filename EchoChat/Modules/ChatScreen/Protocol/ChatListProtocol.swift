//
//  ChatListToViewProtocol.swift
//  EchoChat
//
//  Created by Sandip on 18/06/25.
//

import Foundation
import UIKit

protocol ChatListPresenterToViewProtocol: AnyObject {
    func getChatCards()
    func showError()
}

protocol ChatListInteractorToPresenterProtocol: AnyObject {
    func fetchChatCards()
    func cardsFetchedFailed()
}

protocol ChatListPresentorToInteractorProtocol: AnyObject {
    var presenter: ChatListInteractorToPresenterProtocol? { get set }
    var userCards: [CardUsers]? { get set}
    func fetchUserCards()
}


protocol ChatListPresenterToRouterProtocol: AnyObject {
    static func createModule() -> UIViewController
}


protocol ChatListViewToPresenterProtocol: AnyObject {
    
    var view: ChatListPresenterToViewProtocol? { get set }
    var interactor: ChatListPresentorToInteractorProtocol? { get set }
    var router: ChatListPresenterToRouterProtocol? { get set }
    func updateView()
    func getUserCard(index: Int) -> CardUsers?
    func getTotalRecords() -> Int?
    func updateCardDetails(cardData:CardUsers)
    
}
