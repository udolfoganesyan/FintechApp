//
//  ConversationViewController.swift
//  FintechApp
//
//  Created by Rudolf Oganesyan on 26.09.2020.
//  Copyright © 2020 Рудольф О. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(MessageCell.self, forCellReuseIdentifier: MessageCell.reuseIdentifier)
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.dataSource = self
        tableView.backgroundColor = ThemeManager.currentTheme.backgroundColor
        tableView.keyboardDismissMode = .interactive
        return tableView
    }()
    
    lazy var inputContainerView: UIView = {
        let containerView = InputAccessoryContainerView()
        containerView.fillWithTextField(inputTextField, sendButton: sendButton)
        return containerView
    }()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupKeyboardObservers()
        
        setupTableView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.scrollToRow(at: IndexPath(row: messagesTestData.count - 1, section: 0), at: .top, animated: false)
    }
    
    override var inputAccessoryView: UIView? {
        return inputContainerView
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    private func setupKeyboardObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(handleKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(handleKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc private func handleKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: view.safeAreaInsets.bottom, right: 0)
        } else {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        tableView.scrollIndicatorInsets = tableView.contentInset
    }
    
    @objc private func textChanged(_ sender: UITextField) {
        self.sendButton.isEnabled = !(sender.text?.isEmpty ?? true)
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    @objc private func handleSend() {
        guard let text = inputTextField.text else { return }

        print(text)
    }
}

// MARK: - UITableViewDataSource

extension ConversationViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messagesTestData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MessageCell.reuseIdentifier, for: indexPath) as? MessageCell else {
            return UITableViewCell()
        }
        
        let model = messagesTestData[indexPath.row]
        
        cell.configure(with: model)
        return cell
    }
}
