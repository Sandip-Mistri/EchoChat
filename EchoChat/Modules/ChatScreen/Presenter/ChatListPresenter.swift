//
//  ChatListPresenter.swift
//  EchoChat
//
//  Created by Sandip on 18/06/25.
//

import Foundation

class ChatListPresenter: ChatListViewToPresenterProtocol {
    
    var interactor: ChatListPresentorToInteractorProtocol?
    weak var view: ChatListPresenterToViewProtocol?
    var router: ChatListPresenterToRouterProtocol?
    
    func updateView() {
        interactor?.fetchUserCards()
    }
    
    func getUserCard(index: Int) -> CardUsers? {
        return interactor?.userCards?[index]
    }
    
    func getTotalRecords() -> Int? {
        return interactor?.userCards?.count
    }
    
    func updateCardDetails(cardData: CardUsers) {
        interactor?.userCards?[(cardData.id ?? 1) - 1] = cardData
    }
    
}


// MARK: - ChatListInteractorToPresenterProtocol
extension ChatListPresenter: ChatListInteractorToPresenterProtocol {
    func fetchChatCards() {
        view?.getChatCards()
    }
    
    func cardsFetchedFailed() {
        view?.showError()
    }
}
