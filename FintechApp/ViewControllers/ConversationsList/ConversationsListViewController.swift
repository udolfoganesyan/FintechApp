//
//  ConversationsListViewController.swift
//  FintechApp
//
//  Created by Rudolf Oganesyan on 25.09.2020.
//  Copyright © 2020 Рудольф О. All rights reserved.
//

import UIKit

class ConversationsListViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ConversationCell.nib, forCellReuseIdentifier: ConversationCell.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupNavigationBar()
        setupTableView()
    }
    
    private func setupNavigationBar() {
        title = "Tinkoff Chat"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let settingsButton = UIBarButtonItem(image: #imageLiteral(resourceName: "settings"), style: .plain, target: nil, action: nil)
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
}

// MARK: - UITableViewDelegate

extension ConversationsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let conversationsViewController = ConversationViewController()
        conversationsViewController.title = conversationsTestData[indexPath.section][indexPath.row].name
        navigationController?.pushViewController(conversationsViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension ConversationsListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        conversationsTestData.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Online"
        } else {
            return "History"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        conversationsTestData[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ConversationCell.reuseIdentifier, for: indexPath) as? ConversationCell else {
            return UITableViewCell()
        }
        
        let model = conversationsTestData[indexPath.section][indexPath.row]
        
        cell.configure(with: model)
        
        return cell
    }
}
