//
//  TransferCell.swift
//  TransferList
//
//  Created by Yaser Bahrami on 20.09.2025.
//

import UIKit

final class TransferCell: UITableViewCell {
    static let reuseID = "TransferCell"
    var onStarTapped: (() -> Void)?
    
    private let avatar = AvatarImageView()
    private let nameLabel = UILabel()
    private let subLabel = UILabel()
    private let star = UIButton(type: .system)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
        
        nameLabel.font = .preferredFont(forTextStyle: .headline)
        subLabel.font = .preferredFont(forTextStyle: .subheadline)
        subLabel.textColor = .secondaryLabel
        
        star.setImage(UIImage(systemName: "star"), for: .normal)
        star.addTarget(self, action: #selector(tapStar), for: .touchUpInside)
        star.translatesAutoresizingMaskIntoConstraints = false
        
        let labels = UIStackView(arrangedSubviews: [nameLabel, subLabel])
        labels.axis = .vertical
        labels.spacing = 2
        labels.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(avatar)
        contentView.addSubview(labels)
        contentView.addSubview(star)
        
        avatar.widthAnchor.constraint(equalToConstant: 40).isActive = true
        avatar.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        NSLayoutConstraint.activate([
            avatar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            avatar.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            star.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            star.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            star.widthAnchor.constraint(equalToConstant: 28),
            star.heightAnchor.constraint(equalToConstant: 28),
            
            labels.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 12),
            labels.trailingAnchor.constraint(lessThanOrEqualTo: star.leadingAnchor, constant: -12),
            labels.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            labels.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        ])
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func configure(with item: TransferListItemViewModel) {
        nameLabel.text = item.title
        subLabel.text = item.subtitle
        star.setImage(UIImage(systemName: item.isFavorite ? "star.fill" : "star"), for: .normal)
        if let url = item.avatarURL {
            ImageCache.shared.image(url: url) { [weak self] img in self?.avatar.image = img }
        } else {
            avatar.image = UIImage(systemName: "person.circle")
        }
    }
    
    @objc private func tapStar() { onStarTapped?() }
}
