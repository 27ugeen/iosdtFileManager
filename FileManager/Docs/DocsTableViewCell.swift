//
//  DocsTableViewCell.swift
//  FileManager
//
//  Created by GiN Eugene on 22/3/2022.
//

import UIKit

class DocsTableViewCell: UITableViewCell {
    
    let imgView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.backgroundColor = .white
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 6
        image.clipsToBounds = true
        return image
    }()

    let imageSizeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .systemGray
        return label
    }()
    
    let imageCreationDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .systemGray
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

extension DocsTableViewCell {
    
    private func setupViews() {
        contentView.addSubview(imgView)
        contentView.addSubview(imageCreationDateLabel)
        contentView.addSubview(imageSizeLabel)
        
        let constraints = [
            imgView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            imgView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            imgView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            imgView.heightAnchor.constraint(equalTo: contentView.heightAnchor, constant: -16),
            imgView.widthAnchor.constraint(equalTo: imgView.heightAnchor),
            
            imageCreationDateLabel.leadingAnchor.constraint(equalTo: imgView.trailingAnchor, constant: 42),
            imageCreationDateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 18),
            imageCreationDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            imageSizeLabel.leadingAnchor.constraint(equalTo: imgView.trailingAnchor, constant: 42),
            imageSizeLabel.topAnchor.constraint(equalTo: imageCreationDateLabel.bottomAnchor, constant: 10),
            imageSizeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            imageSizeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -18)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

