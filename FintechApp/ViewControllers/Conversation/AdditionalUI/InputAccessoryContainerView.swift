//
//  InputAccessoryContainerView.swift
//  FintechApp
//
//  Created by Rudolf Oganesyan on 18.10.2020.
//  Copyright © 2020 Рудольф О. All rights reserved.
//

import UIKit

protocol InputDelegate: class {
    func handleSend(text: String, completion: @escaping SuccessCompletion)
}

final class InputAccessoryContainerView: UIView {
    
    weak var delegate: InputDelegate?
    
    private lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.backgroundColor = ThemeManager.currentTheme.incomingCellColor
        textField.textColor = ThemeManager.currentTheme.primaryTextColor
        textField.attributedPlaceholder =
            NSAttributedString(string: "Message",
                               attributes: [NSAttributedString.Key.foregroundColor: ThemeManager.currentTheme.secondaryTextColor])
        textField.addTarget(self, action: #selector(self.textChanged(_:)), for: .editingChanged)
        return textField
    }()
    
    private lazy var sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Send", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    override var intrinsicContentSize: CGSize {
        .zero
    }
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        backgroundColor = ThemeManager.currentTheme.backgroundColor
        autoresizingMask = .flexibleHeight
        
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func handleSend() {
        guard let text = inputTextField.text else { return }
        
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty else { return }
        
        self.sendButton.isEnabled = false
        
        delegate?.handleSend(text: trimmedText, completion: { (success) in
            if success {
                self.inputTextField.text = nil
            } else {
                self.sendButton.isEnabled = true
            }
        })
    }
    
    @objc private func textChanged(_ sender: UITextField) {
        self.sendButton.isEnabled = !(sender.text?.isEmpty ?? true)
    }
}
