//
//  TextViewWithPlaceholder.swift
//  FintechApp
//
//  Created by Rudolf Oganesyan on 09.11.2020.
//  Copyright © 2020 Рудольф О. All rights reserved.
//

import UIKit

final class TextViewWithPlaceholder: UITextView {
    
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Placeholder text"
        label.textColor = ThemeManager.currentTheme.secondaryTextColor
        return label
    }()
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = ThemeManager.currentTheme.incomingCellColor
        textColor = ThemeManager.currentTheme.primaryTextColor
        isScrollEnabled = false
        font = .systemFont(ofSize: 18)
        layer.cornerRadius = 8
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextChange), name: UITextView.textDidChangeNotification, object: nil)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(placeholderLabel)
        placeholderLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        placeholderLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        placeholderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6).isActive = true
        placeholderLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    @objc private func handleTextChange() {
        placeholderLabel.isHidden = !text.isEmpty
    }
    
    func setPlaceholderText(_ text: String) {
        placeholderLabel.text = text
    }
    
    func showPlaceholder() {
        placeholderLabel.isHidden = false
    }
}
