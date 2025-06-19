//
//  RecordingViewPresenter.swift
//  EchoChat
//
//  Created by Sandip on 18/06/25.
//

import Foundation

class RecordingViewPresenter: RecordingViewToPresenterProtocol {
    
    weak var delegate: RecordingModuleDelegate?
    var interactor: RecordingPresentorToInteractorProtocol?
    weak var view: RecordingPresenterToViewProtocol?
    var router: RecordingPresenterToRouterProtocol?
    var cardInfo: CardUsers?
    
    init(interactor: RecordingPresentorToInteractorProtocol? = nil, view: RecordingPresenterToViewProtocol? = nil, router: RecordingPresenterToRouterProtocol? = nil, cardInfo: CardUsers? = nil,delegate: RecordingModuleDelegate? = nil) {
        self.interactor = interactor
        self.view = view
        self.router = router
        self.cardInfo = cardInfo
        self.delegate = delegate
    }
    
    func updateView() {
        
    }
    
    func getUserCardInfo() -> CardUsers? {
        return self.cardInfo
    }
    
    func updateCardDetails(id: Int) {
        self.cardInfo?.isLocked = false
    }
    
    func navigationBackToChat() {
        router?.navigateBackToChat()
    }
    
}


// MARK: - ChatListInteractorToPresenterProtocol
extension RecordingViewPresenter: RecordingInteractorToPresenterProtocol {
    func cardInfoFetched() {
        view?.showCardInfo()
    }
    
    func cardInfoFetchedFailed() {
        view?.showError()
    }
}
