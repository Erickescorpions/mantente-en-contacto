//
//  GroupTableViewCell.swift
//  mantente-en-contacto
//
//  Created by Erick :) Vazquez on 24/08/25.
//

import UIKit

class GroupTableViewCell: UITableViewCell {
    
    let memberImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "person.crop.circle")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.tintColor = .gray
        return iv
    }()
    
    let memberUsername: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .label
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        contentView.addSubview(memberImage)
        contentView.addSubview(memberUsername)
        
        memberImage.translatesAutoresizingMaskIntoConstraints = false
        memberUsername.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            memberImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            memberImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            memberImage.widthAnchor.constraint(equalToConstant: 32),
            memberImage.heightAnchor.constraint(equalToConstant: 32),
            
            memberUsername.leadingAnchor.constraint(equalTo: memberImage.trailingAnchor, constant: 12),
            memberUsername.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            memberUsername.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        memberImage.layer.cornerRadius = 16
    }
}

