//
//  MessageCell.swift
//  FintechApp
//
//  Created by Rudolf Oganesyan on 26.09.2020.
//  Copyright © 2020 Рудольф О. All rights reserved.
//

import UIKit

final class MessageCell: UITableViewCell {
    
    private lazy var messageLabel = UILabel()
    private lazy var messageBackgroundView = UIView()
    private var leadingMessageConstraint: NSLayoutConstraint?
    private var trailingMessageConstraint: NSLayoutConstraint?
    
    private var isIncoming: Bool = false {
        didSet {
            if isIncoming {
                leadingMessageConstraint?.isActive = true
                trailingMessageConstraint?.isActive = false
            } else {
                leadingMessageConstraint?.isActive = false
                trailingMessageConstraint?.isActive = true
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupMessageLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        leadingMessageConstraint?.isActive = false
        trailingMessageConstraint?.isActive = false
    }
    
    private func setupMessageLabel() {
        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        messageBackgroundView.layer.cornerRadius = 8
        messageBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(messageBackgroundView)
        addSubview(messageLabel)
        
        messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true
        messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12).isActive = true
        messageLabel.widthAnchor.constraint(lessThanOrEqualToConstant: bounds.width * 0.75).isActive = true
        leadingMessageConstraint = messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24)
        trailingMessageConstraint = messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24)
        
        messageBackgroundView.topAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -6).isActive = true
        messageBackgroundView.bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 6).isActive = true
        messageBackgroundView.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor, constant: -8).isActive = true
        messageBackgroundView.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor, constant: 8).isActive = true
    }
}

// MARK: - ConfigurableView

extension MessageCell: ConfigurableView {
    
    func configure(with model: MessageCellModel) {
        messageLabel.attributedText = model.attributedText
        isIncoming = model.isIncoming
        let theme = model.theme
        messageBackgroundView.backgroundColor = isIncoming ? theme.incomingCellColor : theme.outgoingCellColor
        messageLabel.textColor = isIncoming ? theme.incomingCellTextColor : theme.outgoingCellTextColor
        backgroundColor = theme.backgroundColor
    }
}
