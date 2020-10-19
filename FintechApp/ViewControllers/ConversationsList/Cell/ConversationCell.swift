//
//  ConversationCell.swift
//  FintechApp
//
//  Created by Rudolf Oganesyan on 25.09.2020.
//  Copyright © 2020 Рудольф О. All rights reserved.
//

import UIKit

protocol ConfigurableView {
    associatedtype ConfigurationModel
    func configure(with model: ConfigurationModel)
}

final class ConversationCell: UITableViewCell {
    
    @IBOutlet private weak var avatarContainer: UIView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var messageLabel: UILabel!
    
    private lazy var onlineBadge = OnlineBadgeView()
    private lazy var avatarView = AvatarImageView(style: .circle)
        
    override func awakeFromNib() {
        super.awakeFromNib()
        
        avatarView.install(on: avatarContainer)
        onlineBadge.install(on: avatarContainer)
        
        backgroundColor = .clear
        let backgroundColorView = UIView()
        backgroundColorView.backgroundColor = UIColor.darkGray.withAlphaComponent(0.3)
        self.selectedBackgroundView = backgroundColorView
    }
}

// MARK: - ConfigurableView

extension ConversationCell: ConfigurableView {
    
    func configure(with model: ConversationCellModel) {
        nameLabel.textColor = ThemeManager.currentTheme.primaryTextColor
        messageLabel.textColor = ThemeManager.currentTheme.secondaryTextColor
        dateLabel.textColor = ThemeManager.currentTheme.secondaryTextColor
        
        nameLabel.text = model.name
        avatarView.setupWith(firstName: model.name, color: .randomLightColor)
        onlineBadge.isHidden = false
        messageLabel.text = model.message
        messageLabel.font = .systemFont(ofSize: 16)
        dateLabel.text = model.date

        if model.message.isEmpty {
            messageLabel.text = "No messages yet"
            messageLabel.font = .italicSystemFont(ofSize: 16)
            dateLabel.text = ""
        }
    }
}
