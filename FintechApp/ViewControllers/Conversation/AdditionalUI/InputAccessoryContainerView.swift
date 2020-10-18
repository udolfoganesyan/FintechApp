//
//  InputAccessoryContainerView.swift
//  FintechApp
//
//  Created by Rudolf Oganesyan on 18.10.2020.
//  Copyright © 2020 Рудольф О. All rights reserved.
//

import UIKit

class InputAccessoryContainerView: UIView {
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        backgroundColor = ThemeManager.currentTheme.backgroundColor
        autoresizingMask = .flexibleHeight
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        .zero
    }
    
    func fillWithTextField(_ inputTextField: UITextField, sendButton: UIButton) {
        addSubview(sendButton)
        addSubview(inputTextField)
        
        inputTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        inputTextField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: 8).isActive = true
        inputTextField.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        inputTextField.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor, constant: -8).isActive = true
        
        sendButton.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: inputTextField.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: inputTextField.heightAnchor).isActive = true
    }
}
