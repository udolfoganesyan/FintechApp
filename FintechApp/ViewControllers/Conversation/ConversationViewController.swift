//
//  ConversationViewController.swift
//  FintechApp
//
//  Created by Rudolf Oganesyan on 26.09.2020.
//  Copyright © 2020 Рудольф О. All rights reserved.
//

import UIKit
import CoreData

final class ConversationViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(MessageCell.self, forCellReuseIdentifier: MessageCell.reuseIdentifier)
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = ThemeManager.currentTheme.backgroundColor
        tableView.keyboardDismissMode = .interactive
        return tableView
    }()
    
    private lazy var inputContainerView: InputAccessoryContainerView = {
        let inputContainerView = InputAccessoryContainerView()
        inputContainerView.delegate = self
        return inputContainerView
    }()
    
    private lazy var fetchedResultsController: NSFetchedResultsController<MessageDB> = {
        let fetchRequest = MessageDB.defaultSortedFetchRequest
        
        let predicate = NSPredicate(format: "channel == %@", channel)
        fetchRequest.predicate = predicate
        
        fetchRequest.returnsObjectsAsFaults = false
        
        fetchRequest.fetchBatchSize = 45
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: coreDataManager.mainContext,
                                             sectionNameKeyPath: "dateForSection",
                                             cacheName: nil)
        frc.delegate = self
        return frc
    }()
    
    private let channel: ChannelDB
    private let channelId: String
    private let coreDataManager: CoreDataManager
    
    override var inputAccessoryView: UIView? {
        return inputContainerView
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    init(channel: ChannelDB, coreDataManager: CoreDataManager) {
        self.channel = channel
        self.channelId = channel.identifier
        self.coreDataManager = coreDataManager
        super.init(nibName: nil, bundle: nil)
        title = channel.name
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupKeyboardObservers()
        setupEndEditingTap()
        layoutTableView()
        
        fetchSavedMessages()
        fetchNewMessagesAndSaveToDB()
    }
    
    private func fetchSavedMessages() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            Logger.log(error.localizedDescription)
        }
    }
    
    private func fetchNewMessagesAndSaveToDB() {
        FirebaseManager.fetchMessagesFor(channelId) { [weak self] (messageUpdates) in
            guard let self = self else { return }
            
            self.coreDataManager.addMessages(messageUpdates.added, forChannelWith: self.channel.objectID)
        }
    }
    
    private func scrollToTheBottom() {
        guard let numberOfSections = fetchedResultsController.sections?.count,
              numberOfSections > 0 else { return }
        guard let numberOfObjectsInTheLastSection = fetchedResultsController.sections?[numberOfSections - 1].numberOfObjects,
              numberOfObjectsInTheLastSection > 0 else { return }
        
        tableView.scrollToRow(at: IndexPath(row: numberOfObjectsInTheLastSection - 1, section: numberOfSections - 1), at: .bottom, animated: true)
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
        
        scrollToTheBottom()
        
        tableView.scrollIndicatorInsets = tableView.contentInset
    }
    
    private func setupEndEditingTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func handleTap() {
        inputContainerView.endEditing()
    }
    
    private func layoutTableView() {
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension ConversationViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        guard anObject is MessageDB else { return }
        
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .fade)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .fade)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .fade)
        case .move:
            guard let indexPath = indexPath,
                  let newIndexPath = newIndexPath else { return }
            tableView.moveRow(at: indexPath, to: newIndexPath)
        default: return
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        
        let indexSet = IndexSet(integer: sectionIndex)
        
        switch type {
        case .insert:
            tableView.insertSections(indexSet, with: .fade)
        case .delete:
            tableView.deleteSections(indexSet, with: .fade)
        default: return
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
        scrollToTheBottom()
    }
}

// MARK: - InputDelegate

extension ConversationViewController: InputDelegate {
    
    func handleSend(text: String, completion: @escaping SuccessCompletion) {
        FirebaseManager.sendMessage(text, to: channelId) { (success) in
            if !success {
                self.showOkAlert("Error", "Could not send message :(")
            }
            completion(success)
        }
    }
}

// MARK: - UITableViewDelegate

extension ConversationViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionDate = fetchedResultsController.sections?[section].name else { return nil }
        
        let headerView = ConversationDateHeader(dateString: sectionDate)
        return headerView
    }
}

// MARK: - UITableViewDataSource

extension ConversationViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        fetchedResultsController.sections?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionInfo = fetchedResultsController.sections?[section] else { return 0 }
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MessageCell.reuseIdentifier, for: indexPath) as? MessageCell else {
            return UITableViewCell()
        }
        
        let messageDB = fetchedResultsController.object(at: indexPath)
        let model = MessageCellModel(messageDB: messageDB)
        
        cell.configure(with: model)
        return cell
    }
}
