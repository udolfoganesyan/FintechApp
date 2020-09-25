//
//  ConversationsListTableViewCell.swift
//  FintechApp
//
//  Created by Rudolf Oganesyan on 25.09.2020.
//  Copyright © 2020 Рудольф О. All rights reserved.
//

import UIKit

class ConversationsListTableViewCell: UITableViewCell {

    @IBOutlet private weak var photoImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var messageLabel: UILabel!
    
    private let onlineBadge = OnlineBadgeView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        onlineBadge.install(on: photoImageView)
    }
}

// MARK: - ConfigurableCell

extension ConversationsListTableViewCell: ConfigurableCell {
    
    typealias ConfigurationModel = ConversationCellModel
    
    func configure(with model: ConversationCellModel) {
        nameLabel.text = model.name
        onlineBadge.isHidden = !model.isOnline
        messageLabel.text = model.message
        if model.message.isEmpty {
            messageLabel.text = "No messages yet"
            messageLabel.font = .italicSystemFont(ofSize: 16)
        } else if model.hasUnreadMessages {
            messageLabel.font = .boldSystemFont(ofSize: 16)
        }
    }
}
