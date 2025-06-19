//
//  RecordingViewProtocol.swift
//  EchoChat
//
//  Created by Sandip on 18/06/25.
//

import Foundation
import UIKit

protocol RecordingModuleDelegate: AnyObject {
    func didUpdateCard(_ updatedCard: CardUsers)
}

protocol RecordingPresenterToViewProtocol: AnyObject {
    func showCardInfo()
    func showError()
}

protocol RecordingInteractorToPresenterProtocol: AnyObject {
    func cardInfoFetched()
    func cardInfoFetchedFailed()
}

protocol RecordingPresentorToInteractorProtocol: AnyObject {
    var presenter: RecordingInteractorToPresenterProtocol? { get set }
    var userCardInfo: CardUsers? { get set}
    func fetchUserCardInfo()
    func updateCardDetails(id: Int)
    
}

protocol RecordingPresenterToRouterProtocol: AnyObject {
    static func createModule(cardInfo:CardUsers,delegate: RecordingModuleDelegate?) -> UIViewController
    func navigateBackToChat()

}

protocol RecordingViewToPresenterProtocol: AnyObject {
    var view: RecordingPresenterToViewProtocol? { get set }
    var interactor: RecordingPresentorToInteractorProtocol? { get set }
    var router: RecordingPresenterToRouterProtocol? { get set }
    var delegate: RecordingModuleDelegate? { get set }
    func updateView()
    func getUserCardInfo() -> CardUsers?
    func updateCardDetails(id: Int)
    func navigationBackToChat()
}
