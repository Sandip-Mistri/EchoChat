//
//  ChatCardItem.swift
//  EchoChat
//
//  Created by Sandip on 18/06/25.
//

import UIKit

class ChatCardCollectionViewCell: UICollectionViewCell, NibProvidable & ReusableView {

    @IBOutlet weak var ivUserImage: UIImageView!
    @IBOutlet private weak var lblUserDetail: UILabel!
    @IBOutlet private weak var lblQuestion: UILabel!
    @IBOutlet weak var imgCheckMark: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setLayout()
    }
    
    func setCardData(data: CardUsers){
        lblQuestion.text = data.question
        lblUserDetail.text = data.name
        ivUserImage.image = UIImage(named: data.profilePic ?? "")
        if data.isLocked! {
            imgCheckMark.isHidden = true
        } else {
            imgCheckMark.isHidden = false
        }
    }
}

extension ChatCardCollectionViewCell {
    
    private func setLayout() {
        
        self.lblUserDetail.font = FontManager.shared.font(.bold, size: 15)
        self.lblQuestion.font = FontManager.shared.font(.regular, size: 10)
        self.lblUserDetail.textColor = .FFFFFF
        self.lblQuestion.textColor = .CFCFFE.withAlphaComponent(0.7)
        
    }
}
