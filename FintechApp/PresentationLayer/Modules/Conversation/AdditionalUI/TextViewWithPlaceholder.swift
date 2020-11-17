//
//  TextViewWithPlaceholder.swift
//  FintechApp
//
//  Created by Rudolf Oganesyan on 09.11.2020.
//  Copyright © 2020 Рудольф О. All rights reserved.
//

import UIKit

final class TextViewWithPlaceholder: UITextView {
    
    private let theme: Theme
    
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Placeholder text"
        label.textColor = theme.secondaryTextColor
        return label
    }()
    
    init(theme: Theme) {
        self.theme = theme
        super.init(frame: CGRect.zero, textContainer: nil)
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = theme.incomingCellColor
        textColor = theme.primaryTextColor
        isScrollEnabled = false
        font = .systemFont(ofSize: 18)
        layer.cornerRadius = 8
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextChange), name: UITextView.textDidChangeNotification, object: nil)
        
        addSubviewInBounds(placeholderLabel, topPadding: 8, leadingPadding: 6)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
