//
//  ConversationsViewController.swift
//  FintechApp
//
//  Created by Rudolf Oganesyan on 25.09.2020.
//  Copyright © 2020 Рудольф О. All rights reserved.
//

import UIKit

final class ConversationsViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ConversationCell.nib, forCellReuseIdentifier: ConversationCell.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 80
        return tableView
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "add"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(handleAddChannel), for: .touchUpInside)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.6
        button.layer.shadowOffset = .zero
        button.layer.shadowRadius = 4
        return button
    }()
    
    private lazy var frcDelegate = FetchedResultsControllerDelegate<ChannelDB>(tableView: tableView)
    private var actionToEnable: UIAlertAction?
    private let conversationsInteractor: ConversationsInteractorProtocol
    private let presentationAssembly: PresentationAssemblyProtocol
    
    init(conversationsInteractor: ConversationsInteractorProtocol, presentationAssembly: PresentationAssemblyProtocol) {
        self.presentationAssembly = presentationAssembly
        self.conversationsInteractor = conversationsInteractor
        super.init(nibName: nil, bundle: nil)
        
        conversationsInteractor.fetchedResultsController.delegate = frcDelegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        layoutTableView()
        setupAddButton()
        updateTheme()
        
        conversationsInteractor.fetchSavedChannels()
        conversationsInteractor.fetchNewChannelsAndSaveToDB()
    }
    
    private func setupNavigationBar() {
        title = "Channels"
        
        let settingsButton = UIBarButtonItem(image: #imageLiteral(resourceName: "settings"), style: .plain, target: self, action: #selector(handleSettings))
        settingsButton.tintColor = UIColor(red: 0.329, green: 0.329, blue: 0.345, alpha: 0.9)
        navigationItem.setLeftBarButton(settingsButton, animated: true)
        
        let avatarView = AvatarImageView(style: .circle)
        let avatarViewContainer = UIView()
        avatarView.install(on: avatarViewContainer)
        avatarView.setupWith(firstName: "Rudolf", lastName: "Oganesyan", color: #colorLiteral(red: 0.8941176471, green: 0.9098039216, blue: 0.168627451, alpha: 1))
        let profileButton = UIBarButtonItem(customView: avatarViewContainer)
        profileButton.customView?.translatesAutoresizingMaskIntoConstraints = false
        profileButton.customView?.heightAnchor.constraint(equalToConstant: 40).isActive = true
        profileButton.customView?.widthAnchor.constraint(equalToConstant: 40).isActive = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleProfileTap))
        avatarViewContainer.addGestureRecognizer(tapGesture)
        navigationItem.setRightBarButton(profileButton, animated: true)
    }
    
    @objc private func handleSettings() {
        let settingsViewController = presentationAssembly.themeSettingsViewController()
        settingsViewController.delegate = self
        navigationController?.pushViewController(settingsViewController, animated: true)
    }
    
    @objc private func handleProfileTap() {
        let profileViewController = presentationAssembly.profileViewController()
        present(profileViewController, animated: true)
    }
    
    private func layoutTableView() {
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    private func setupAddButton() {
        view.addSubview(addButton)
        addButton.widthAnchor.constraint(equalToConstant: 56).isActive = true
        addButton.heightAnchor.constraint(equalTo: addButton.widthAnchor).isActive = true
        addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24).isActive = true
        addButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24).isActive = true
    }
    
    @objc private func handleAddChannel() {
        let alert = UIAlertController(title: "Create new channel", message: nil, preferredStyle: .alert)
        
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = "Channel name here..."
            textField.addTarget(self, action: #selector(self.textChanged(_:)), for: .editingChanged)
        }
        
        let createAction = UIAlertAction(title: "Create", style: .default, handler: { _ in
            guard let textField = alert.textFields?.first,
                  let name: String = textField.text else {
                return
            }
            
            self.conversationsInteractor.createFBChannelWith(name) { (success) in
                if !success {
                    self.showOkAlert("Error", "Could not create channel :(")
                }
            }
        })
        self.actionToEnable = createAction
        createAction.isEnabled = false
        alert.addAction(createAction)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc private func textChanged(_ sender: UITextField) {
        self.actionToEnable?.isEnabled = !(sender.text?.isEmpty ?? true)
    }
}

// MARK: - UITableViewDelegate

extension ConversationsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedChannel = conversationsInteractor.fetchedResultsController.object(at: indexPath)
        let conversationsViewController = presentationAssembly.conversationViewController(forChannel: selectedChannel)
        navigationController?.pushViewController(conversationsViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension ConversationsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionInfo = conversationsInteractor.fetchedResultsController.sections?[section] else { return 0 }
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ConversationCell.reuseIdentifier, for: indexPath) as? ConversationCell else {
            return UITableViewCell()
        }
        
        let channelDB = conversationsInteractor.fetchedResultsController.object(at: indexPath)
        let model = ConversationCellModel(channelDB: channelDB, theme: conversationsInteractor.currentTheme)
        cell.configure(with: model)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let channel = conversationsInteractor.fetchedResultsController.object(at: indexPath)
            conversationsInteractor.deleteFBChannelWith(channelId: channel.identifier) { (success) in
                if !success {
                    self.showOkAlert("Error", "Could not delete channel :(")
                }
            }
        }
    }
}

// MARK: - SettingsDelegate

extension ConversationsViewController: SettingsDelegate {
    
    func didChangeTheme() {
        updateTheme()
    }
    
    private func updateTheme() {
        tableView.backgroundColor = conversationsInteractor.currentTheme.backgroundColor
        tableView.reloadData()
        
        navigationController?.navigationBar.barTintColor = conversationsInteractor.currentTheme.backgroundColor
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: conversationsInteractor.currentTheme.primaryTextColor]
    }
}
