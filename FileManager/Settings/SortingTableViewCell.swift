//
//  SettingsTableViewCell.swift
//  FileManager
//
//  Created by GiN Eugene on 21/3/2022.
//

import UIKit

class SortingTableViewCell: UITableViewCell {
    
    let sortingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "alphabetically"
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    let toggle: UISwitch = {
        let toggle = UISwitch()
        toggle.translatesAutoresizingMaskIntoConstraints = false
        toggle.isOn = true
        toggle.onTintColor = .systemGreen
        return toggle
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension SortingTableViewCell {
    
    private func setupViews() {
        contentView.addSubview(sortingLabel)
        contentView.addSubview(toggle)
        
        let constraints = [
            sortingLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            sortingLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            sortingLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            toggle.leadingAnchor.constraint(equalTo: sortingLabel.trailingAnchor),
            toggle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            toggle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
