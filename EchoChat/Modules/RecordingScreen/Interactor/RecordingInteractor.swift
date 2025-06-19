//
//  RecordingInteractor.swift
//  EchoChat
//
//  Created by Sandip on 18/06/25.
//

import Foundation

class RecordingInteractor: RecordingPresentorToInteractorProtocol {
    
    var presenter: RecordingInteractorToPresenterProtocol?
    var userCardInfo: CardUsers?
    
    func fetchUserCardInfo() {
    }
    
    func updateCardDetails(id: Int){
        guard var card = userCardInfo else { return }
        card.isLocked = false
        userCardInfo = card
    }
    
}
