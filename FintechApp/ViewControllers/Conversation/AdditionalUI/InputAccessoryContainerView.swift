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
    
    private lazy var inputTextView: TextViewWithPlaceholder = {
        let textView = TextViewWithPlaceholder()
        textView.setPlaceholderText("Message")
        textView.delegate = self
        return textView
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
        addSubview(inputTextView)
        
        inputTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        inputTextView.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: 8).isActive = true
        inputTextView.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        inputTextView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor, constant: -8).isActive = true
        
        sendButton.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: inputTextView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: inputTextView.heightAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func handleSend() {
        guard let text = inputTextView.text else { return }
        
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty else { return }
        
        self.sendButton.isEnabled = false
        
        delegate?.handleSend(text: trimmedText, completion: { (success) in
            if success {
                self.inputTextView.text = ""
                self.inputTextView.showPlaceholder()
            } else {
                self.sendButton.isEnabled = true
            }
        })
    }
    
    func endEditing() {
        inputTextView.resignFirstResponder()
    }
}

// MARK: - UITextViewDelegate

extension InputAccessoryContainerView: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        self.sendButton.isEnabled = !textView.text.isEmpty
    }
}
