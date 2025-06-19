//
//  ChatCardsInteractor.swift
//  EchoChat
//
//  Created by Sandip on 18/06/25.
//

import Foundation

class ChatCardsInteractor: ChatListPresentorToInteractorProtocol {
    
    weak var presenter: (ChatListInteractorToPresenterProtocol)?
    var userCards: [CardUsers]?
    
    func fetchUserCards() {
        if let path = Bundle.main.path(forResource: "mockUserData", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONDecoder().decode(ChatCardItems.self, from: data)
                userCards = jsonResult.users
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }
    }
}
