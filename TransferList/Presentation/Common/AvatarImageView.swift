//
//  AvatarImageView.swift
//  TransferList
//
//  Created by Yaser Bahrami on 20.09.2025.
//


import UIKit

final class AvatarImageView: UIImageView {
    convenience init() { self.init(frame: .zero) }

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentMode = .scaleAspectFill
        clipsToBounds = true
        backgroundColor = .tertiarySystemFill
        translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        contentMode = .scaleAspectFill
        clipsToBounds = true
        backgroundColor = .tertiarySystemFill
        translatesAutoresizingMaskIntoConstraints = false
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = min(bounds.width, bounds.height) / 2
    }
}
