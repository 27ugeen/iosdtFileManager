//
//  SettingsViewController.swift
//  FileManager
//
//  Created by GiN Eugene on 20/3/2022.
//

import UIKit
import SwiftUI

class SettingsViewController: UIViewController {
    
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    let sortingCellID = String(describing: SortingTableViewCell.self)
    let passwordCellID = String(describing: PasswordChangeTableViewCell.self)

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Settings"
        view.backgroundColor = .white
        
        setupTableView()
        setupViews()
    }
}

extension SettingsViewController {
    func setupTableView() {
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(SortingTableViewCell.self, forCellReuseIdentifier: sortingCellID)
        tableView.register(PasswordChangeTableViewCell.self, forCellReuseIdentifier: passwordCellID)
        
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension SettingsViewController {
    func setupViews() {

        let constraints = [
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

extension SettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: sortingCellID, for: indexPath) as! SortingTableViewCell
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: passwordCellID, for: indexPath) as! PasswordChangeTableViewCell
            cell.accessoryType = .disclosureIndicator
            return cell
        default:
            return UITableViewCell()
        }
        
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            return
        case 1:
            let loginVC = LogInViewController(loginViewModel: LoginViewModel().self)
            loginVC.loginButton.tag = 3
            self.present(loginVC, animated: true)
        default:
            return
        }
    }
}
