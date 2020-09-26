//
//  ConversationViewController.swift
//  FintechApp
//
//  Created by Rudolf Oganesyan on 26.09.2020.
//  Copyright © 2020 Рудольф О. All rights reserved.
//

import UIKit

class ConversationViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tableView.scrollToRow(at: IndexPath(row: conversationsTestData.count - 1, section: 0), at: .bottom, animated: true)
    }
    
    private func setupTableView() {
        tableView.register(ConversationTableViewCell.self, forCellReuseIdentifier: ConversationTableViewCell.reuseIdentifier)
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
    }
}

// MARK: - UITableViewDataSource

extension ConversationViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        conversationsTestData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ConversationTableViewCell.reuseIdentifier, for: indexPath) as? ConversationTableViewCell else {
            return UITableViewCell()
        }
        
        let model = conversationsTestData[indexPath.row]
        
        cell.configure(with: model)
        cell.isIncoming = indexPath.row % 2 == 0 ? true : false
        return cell
    }
}
