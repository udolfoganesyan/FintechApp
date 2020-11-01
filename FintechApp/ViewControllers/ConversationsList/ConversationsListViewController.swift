//
//  ConversationsListViewController.swift
//  FintechApp
//
//  Created by Rudolf Oganesyan on 25.09.2020.
//  Copyright © 2020 Рудольф О. All rights reserved.
//

import UIKit
import CoreData

final class ConversationsListViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ConversationCell.nib, forCellReuseIdentifier: ConversationCell.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "add"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(handleAddChannel), for: .touchUpInside)
        return button
    }()
    
    private lazy var fetchedResultsController: NSFetchedResultsController<ChannelDB> = {
        let fetchRequest: NSFetchRequest<ChannelDB> = ChannelDB.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "lastActivity", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchRequest.fetchBatchSize = 22
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: coreDataManager.mainContext,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)
        frc.delegate = self
        return frc
    }()
    
    private var actionToEnable: UIAlertAction?
    private let coreDataManager: CoreDataManager
    
    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupTableView()
        setupAddButton()
        updateTheme()
        
        fetchSavedChannels()
        fetchNewChannelsAndSaveToDB()
    }
    
    private func fetchSavedChannels() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            Logger.log(error.localizedDescription)
        }
    }
    
    private func fetchNewChannelsAndSaveToDB() {
        FirebaseManager.fetchChannels { (channels) in
            self.coreDataManager.performSave { (context) in
                channels.forEach { _ = ChannelDB(channel: $0, context: context) }
            }
        }
    }
    
    private func setupNavigationBar() {
        title = "Channels"
        
        let settingsButton = UIBarButtonItem(image: #imageLiteral(resourceName: "settings"), style: .plain, target: self, action: #selector(handleSettings))
        settingsButton.tintColor = Constants.Colors.settingsGray
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
        let settingsViewController = ThemeSettingsViewController()
        settingsViewController.delegate = self
        navigationController?.pushViewController(settingsViewController, animated: true)
    }
    
    @objc private func handleProfileTap() {
        let profileViewController = ProfileViewController()
        present(profileViewController, animated: true)
    }
    
    private func setupTableView() {
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
            
            FirebaseManager.createChannelWith(name) { (success) in
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

extension ConversationsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedChannel = fetchedResultsController.object(at: indexPath)
        let conversationsViewController = ConversationViewController(channelId: selectedChannel.identifier, coreDataManager: coreDataManager)
        conversationsViewController.title = selectedChannel.name
        navigationController?.pushViewController(conversationsViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension ConversationsListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionInfo = fetchedResultsController.sections?[section] else { return 0 }
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ConversationCell.reuseIdentifier, for: indexPath) as? ConversationCell else {
            return UITableViewCell()
        }
        
        let channelDB = fetchedResultsController.object(at: indexPath)
        let model = ConversationCellModel(channelDB: channelDB)
        
        cell.configure(with: model)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let channel = fetchedResultsController.object(at: indexPath)
            FirebaseManager.deleteChannelWith(channelId: channel.identifier) { (success) in
                if success {
                    self.coreDataManager.deleteChannelWith(objectID: channel.objectID)
                }
            }
        }
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension ConversationsListViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        guard let channelDB = anObject as? ChannelDB else { return }
        
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .fade)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .fade)
        case .update:
            guard let indexPath = indexPath,
                  let cell = tableView.cellForRow(at: indexPath) as? ConversationCell else { return }
            let model = ConversationCellModel(channelDB: channelDB)
            cell.configure(with: model)
        case .move:
            guard let indexPath = indexPath,
                  let newIndexPath = newIndexPath else { return }
            tableView.moveRow(at: indexPath, to: newIndexPath)
        default: return
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}

// MARK: - SettingsDelegate

extension ConversationsListViewController: SettingsDelegate {
    
    func didChangeTheme() {
        updateTheme()
    }
    
    private func updateTheme() {
        tableView.backgroundColor = ThemeManager.currentTheme.backgroundColor
        tableView.reloadData()
        
        navigationController?.navigationBar.barTintColor = ThemeManager.currentTheme.backgroundColor
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: ThemeManager.currentTheme.primaryTextColor]
    }
}
