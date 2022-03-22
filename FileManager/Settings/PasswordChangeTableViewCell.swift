//
//  PasswordChangeTableViewCell.swift
//  FileManager
//
//  Created by GiN Eugene on 21/3/2022.
//

import UIKit

class PasswordChangeTableViewCell: UITableViewCell {

    let passwordLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "change password"
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PasswordChangeTableViewCell {
    
    private func setupViews() {
        contentView.addSubview(passwordLabel)
        
        let constraints = [
            passwordLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            passwordLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            passwordLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            passwordLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
