//
//  ViewController.swift
//  EchoChat
//
//  Created by Sandip on 18/06/25.
//

import UIKit

class ChatScreenViewController: UIViewController, ZoomTransitionDelegate, StoryboardInstantiable {

    @IBOutlet weak var pendingButton: UIButton!
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var profileProgressLabel: UILabel!
    @IBOutlet weak var profileImageView: KDCircularProgress!
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var lblHeaderDesc: UILabel!
    @IBOutlet weak var lblHeaderText: UILabel!
    @IBOutlet private weak var cvChatCards: UICollectionView! {
        didSet {
            cvChatCards.registerNib(ChatCardCollectionViewCell.self)
            cvChatCards.delegate = self
            cvChatCards.dataSource = self
        }
    }
    var presenter: ChatListViewToPresenterProtocol?
    private var selectedIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.updateView()
        self.setCustomFont()
        self.prepareCollectionView()
        profileImageView.animate(fromAngle: 0, toAngle: 360, duration: 0.5) { completed in
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationController?.navigationBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
        self.navigationItem.backButtonTitle = ""
        self.tabBarController?.navigationItem.backButtonTitle = ""
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

}

// MARK: -
// MARK: Private methods
extension ChatScreenViewController {
    private func prepareCollectionView() {
        self.cvChatCards.reloadWithAnimations()
    }
    
    private func setCustomFont(){
        self.lblHeaderText.font = FontManager.shared.font(.bold, size: 22)
        self.profileProgressLabel.font = FontManager.shared.font(.bold, size: 10.5)
        //self.lblHeaderDesc.font = FontManager.shared.font(.italic, size: 12)
        self.lblCount.font = FontManager.shared.font(.bold, size: 10)
        self.chatButton.titleLabel?.font = FontManager.shared.font(.bold, size: 22)
        self.pendingButton.titleLabel?.font = FontManager.shared.font(.bold, size: 22)
    }
}

// MARK: -
// MARK: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension ChatScreenViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.getTotalRecords() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ChatCardCollectionViewCell = collectionView.dequeueCell(cellClass: ChatCardCollectionViewCell.self, forIndexPath: indexPath)
        
        cell.setCardData(data: (presenter?.getUserCard(index: indexPath.row))!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.size.width
        let cellWidth = (width - 30) / 2.25
        return CGSize(width: cellWidth, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        let controller = RecordingViewRouter.createModule(cardInfo: (presenter?.getUserCard(index: indexPath.row))!,delegate: self)
        controller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: -
// MARK: ChatListPresenterToViewProtocol
extension ChatScreenViewController: ChatListPresenterToViewProtocol {
   
    func getChatCards() {
        self.cvChatCards.reloadData()
    }
    
    func showError() {
        let alert = UIAlertController(title: "Alert", message: "Problem Fetching User Cards", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}


// MARK: -
// MARK: ZoomTransitionAnimating
extension ChatScreenViewController: ZoomTransitionAnimating {
    var transitionSourceImageView: UIImageView {
        let selectedIndexPath = self.cvChatCards.indexPathsForSelectedItems!.first!
        let cell = self.cvChatCards.cellForItem(at: selectedIndexPath) as! ChatCardCollectionViewCell
        let imageView = UIImageView(image: cell.ivUserImage.image)
        imageView.contentMode = cell.ivUserImage.contentMode;
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = false
        imageView.frame = cell.ivUserImage.convert(cell.ivUserImage.frame, to: self.view)
        return imageView;
    }

    var transitionSourceBackgroundColor: UIColor? {
        return self.cvChatCards.backgroundColor
    }

    var transitionDestinationImageViewFrame: CGRect {
        if let selectedIndexPath,
           let cell = self.cvChatCards.cellForItem(at: selectedIndexPath) as? ChatCardCollectionViewCell {
            let cellFrameInSuperview = cell.ivUserImage.convert(cell.ivUserImage.frame, to: self.view)
            return cellFrameInSuperview
        }
        return CGRect.zero
    }
}

// Adopt delegate to update the list data 
extension ChatScreenViewController: RecordingModuleDelegate {
    func didUpdateCard(_ updatedCard: CardUsers) {
        presenter?.updateCardDetails(cardData: updatedCard)
        if let selectedIndexPath {
            cvChatCards.reloadWithAnimations(indexPath: selectedIndexPath)
        }
    }
}
