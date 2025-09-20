//
//  DetailsViewController.swift
//  TransferList
//
//  Created by Yaser Bahrami on 20.09.2025.
//

import UIKit

final class DetailsViewController: UIViewController {
    private let vm: DetailsViewModel

    // MARK: UI
    private let scroll = UIScrollView()
    private let content = UIStackView()

    // Header
    private let headerCard = UIView()
    private let avatar = AvatarImageView()
    private let nameLabel = UILabel()
    private let emailLabel = UILabel()

    // Info cards
    private let cardInfoCard = UIView()
    private let cardIcon = UIImageView(image: UIImage(systemName: "creditcard"))
    private let cardTitleLabel = UILabel()
    private let cardSubtitleLabel = UILabel()

    private let lastTransferCard = UIView()
    private let lastIcon = UIImageView(image: UIImage(systemName: "clock"))
    private let lastTitleLabel = UILabel()
    private let lastSubtitleLabel = UILabel()

    private let statsCard = UIView()
    private let transfersTitle = UILabel()
    private let transfersValue = UILabel()
    private let totalTitle = UILabel()
    private let totalValue = UILabel()

    private let noteCard = UIView()
    private let noteIcon = UIImageView(image: UIImage(systemName: "note.text"))
    private let noteTitleLabel = UILabel()
    private let noteBodyLabel = UILabel()

    private static let numberFormatter: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        return f
    }()

    // MARK: Init
    init(viewModel: DetailsViewModel) {
        self.vm = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        title = "Details"

        configureNav()
        buildHierarchy()
        layout()
        style()
        render()

        vm.onChanged = { [weak self] in
            self?.updateStar()
        }
    }

    // MARK: UI Setup
    private func configureNav() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: vm.isFavorite ? "star.fill" : "star"),
            style: .plain,
            target: self,
            action: #selector(toggleFavorite)
        )
    }

    private func buildHierarchy() {
        content.axis = .vertical
        content.spacing = 12
        content.translatesAutoresizingMaskIntoConstraints = false
        scroll.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(scroll)
        scroll.addSubview(content)

        // Header card
        [avatar, nameLabel, emailLabel].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        headerCard.translatesAutoresizingMaskIntoConstraints = false
        headerCard.addSubview(avatar)
        headerCard.addSubview(nameLabel)
        headerCard.addSubview(emailLabel)

        // Card info
        [cardIcon, cardTitleLabel, cardSubtitleLabel].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        cardInfoCard.translatesAutoresizingMaskIntoConstraints = false
        cardInfoCard.addSubview(cardIcon)
        cardInfoCard.addSubview(cardTitleLabel)
        cardInfoCard.addSubview(cardSubtitleLabel)

        // Last transfer
        [lastIcon, lastTitleLabel, lastSubtitleLabel].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        lastTransferCard.translatesAutoresizingMaskIntoConstraints = false
        lastTransferCard.addSubview(lastIcon)
        lastTransferCard.addSubview(lastTitleLabel)
        lastTransferCard.addSubview(lastSubtitleLabel)

        // Stats
        [transfersTitle, transfersValue, totalTitle, totalValue].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        statsCard.translatesAutoresizingMaskIntoConstraints = false
        statsCard.addSubview(transfersTitle)
        statsCard.addSubview(transfersValue)
        statsCard.addSubview(totalTitle)
        statsCard.addSubview(totalValue)

        // Note
        [noteIcon, noteTitleLabel, noteBodyLabel].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        noteCard.translatesAutoresizingMaskIntoConstraints = false
        noteCard.addSubview(noteIcon)
        noteCard.addSubview(noteTitleLabel)
        noteCard.addSubview(noteBodyLabel)

        [headerCard, cardInfoCard, lastTransferCard, statsCard, noteCard].forEach { content.addArrangedSubview($0) }
    }

    private func layout() {
        let g = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            scroll.leadingAnchor.constraint(equalTo: g.leadingAnchor),
            scroll.trailingAnchor.constraint(equalTo: g.trailingAnchor),
            scroll.topAnchor.constraint(equalTo: g.topAnchor),
            scroll.bottomAnchor.constraint(equalTo: g.bottomAnchor),

            content.leadingAnchor.constraint(equalTo: scroll.contentLayoutGuide.leadingAnchor, constant: 16),
            content.trailingAnchor.constraint(equalTo: scroll.contentLayoutGuide.trailingAnchor, constant: -16),
            content.topAnchor.constraint(equalTo: scroll.contentLayoutGuide.topAnchor, constant: 16),
            content.bottomAnchor.constraint(equalTo: scroll.contentLayoutGuide.bottomAnchor, constant: -16),
            content.widthAnchor.constraint(equalTo: scroll.frameLayoutGuide.widthAnchor, constant: -32)
        ])

        avatar.widthAnchor.constraint(equalToConstant: 88).isActive = true
        avatar.heightAnchor.constraint(equalToConstant: 88).isActive = true

        NSLayoutConstraint.activate([
            avatar.leadingAnchor.constraint(equalTo: headerCard.leadingAnchor, constant: 16),
            avatar.topAnchor.constraint(equalTo: headerCard.topAnchor, constant: 16),

            nameLabel.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: headerCard.trailingAnchor, constant: -16),
            nameLabel.topAnchor.constraint(equalTo: avatar.topAnchor),

            emailLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            emailLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),

            avatar.bottomAnchor.constraint(equalTo: headerCard.bottomAnchor, constant: -16)
        ])

        NSLayoutConstraint.activate([
            cardIcon.leadingAnchor.constraint(equalTo: cardInfoCard.leadingAnchor, constant: 16),
            cardIcon.centerYAnchor.constraint(equalTo: cardInfoCard.centerYAnchor),
            cardIcon.widthAnchor.constraint(equalToConstant: 24),
            cardIcon.heightAnchor.constraint(equalToConstant: 20),

            cardTitleLabel.leadingAnchor.constraint(equalTo: cardIcon.trailingAnchor, constant: 12),
            cardTitleLabel.trailingAnchor.constraint(equalTo: cardInfoCard.trailingAnchor, constant: -16),
            cardTitleLabel.topAnchor.constraint(equalTo: cardInfoCard.topAnchor, constant: 14),

            cardSubtitleLabel.leadingAnchor.constraint(equalTo: cardTitleLabel.leadingAnchor),
            cardSubtitleLabel.trailingAnchor.constraint(equalTo: cardTitleLabel.trailingAnchor),
            cardSubtitleLabel.topAnchor.constraint(equalTo: cardTitleLabel.bottomAnchor, constant: 2),
            cardSubtitleLabel.bottomAnchor.constraint(equalTo: cardInfoCard.bottomAnchor, constant: -14),
        ])

        NSLayoutConstraint.activate([
            lastIcon.leadingAnchor.constraint(equalTo: lastTransferCard.leadingAnchor, constant: 16),
            lastIcon.centerYAnchor.constraint(equalTo: lastTransferCard.centerYAnchor),
            lastIcon.widthAnchor.constraint(equalToConstant: 22),
            lastIcon.heightAnchor.constraint(equalToConstant: 22),

            lastTitleLabel.leadingAnchor.constraint(equalTo: lastIcon.trailingAnchor, constant: 12),
            lastTitleLabel.trailingAnchor.constraint(equalTo: lastTransferCard.trailingAnchor, constant: -16),
            lastTitleLabel.topAnchor.constraint(equalTo: lastTransferCard.topAnchor, constant: 14),

            lastSubtitleLabel.leadingAnchor.constraint(equalTo: lastTitleLabel.leadingAnchor),
            lastSubtitleLabel.trailingAnchor.constraint(equalTo: lastTitleLabel.trailingAnchor),
            lastSubtitleLabel.topAnchor.constraint(equalTo: lastTitleLabel.bottomAnchor, constant: 2),
            lastSubtitleLabel.bottomAnchor.constraint(equalTo: lastTransferCard.bottomAnchor, constant: -14),
        ])

        NSLayoutConstraint.activate([
            transfersTitle.leadingAnchor.constraint(equalTo: statsCard.leadingAnchor, constant: 16),
            transfersTitle.topAnchor.constraint(equalTo: statsCard.topAnchor, constant: 14),

            transfersValue.leadingAnchor.constraint(equalTo: transfersTitle.leadingAnchor),
            transfersValue.topAnchor.constraint(equalTo: transfersTitle.bottomAnchor, constant: 2),
            transfersValue.bottomAnchor.constraint(equalTo: statsCard.bottomAnchor, constant: -14),

            totalTitle.leadingAnchor.constraint(greaterThanOrEqualTo: transfersValue.trailingAnchor, constant: 16),
            totalTitle.trailingAnchor.constraint(equalTo: statsCard.trailingAnchor, constant: -16),
            totalTitle.topAnchor.constraint(equalTo: statsCard.topAnchor, constant: 14),

            totalValue.leadingAnchor.constraint(equalTo: totalTitle.leadingAnchor),
            totalValue.trailingAnchor.constraint(equalTo: statsCard.trailingAnchor, constant: -16),
            totalValue.topAnchor.constraint(equalTo: totalTitle.bottomAnchor, constant: 2),
            totalValue.bottomAnchor.constraint(equalTo: statsCard.bottomAnchor, constant: -14),
        ])

        NSLayoutConstraint.activate([
            noteIcon.leadingAnchor.constraint(equalTo: noteCard.leadingAnchor, constant: 16),
            noteIcon.topAnchor.constraint(equalTo: noteCard.topAnchor, constant: 14),
            noteIcon.widthAnchor.constraint(equalToConstant: 22),
            noteIcon.heightAnchor.constraint(equalToConstant: 22),

            noteTitleLabel.leadingAnchor.constraint(equalTo: noteIcon.trailingAnchor, constant: 12),
            noteTitleLabel.trailingAnchor.constraint(equalTo: noteCard.trailingAnchor, constant: -16),
            noteTitleLabel.topAnchor.constraint(equalTo: noteCard.topAnchor, constant: 14),

            noteBodyLabel.leadingAnchor.constraint(equalTo: noteTitleLabel.leadingAnchor),
            noteBodyLabel.trailingAnchor.constraint(equalTo: noteTitleLabel.trailingAnchor),
            noteBodyLabel.topAnchor.constraint(equalTo: noteTitleLabel.bottomAnchor, constant: 6),
            noteBodyLabel.bottomAnchor.constraint(equalTo: noteCard.bottomAnchor, constant: -14)
        ])
    }

    private func style() {
        [headerCard, cardInfoCard, lastTransferCard, statsCard, noteCard].forEach {
            $0.backgroundColor = .secondarySystemGroupedBackground
            $0.layer.cornerRadius = 14
        }

        nameLabel.font = .preferredFont(forTextStyle: .title2)
        emailLabel.font = .preferredFont(forTextStyle: .subheadline)
        emailLabel.textColor = .secondaryLabel

        cardIcon.tintColor = .tertiaryLabel
        cardTitleLabel.font = .preferredFont(forTextStyle: .headline)
        cardSubtitleLabel.font = .preferredFont(forTextStyle: .subheadline)
        cardSubtitleLabel.textColor = .secondaryLabel

        lastIcon.tintColor = .tertiaryLabel
        lastTitleLabel.font = .preferredFont(forTextStyle: .headline)
        lastSubtitleLabel.font = .preferredFont(forTextStyle: .subheadline)
        lastSubtitleLabel.textColor = .secondaryLabel

        transfersTitle.text = "Transfers"
        transfersTitle.font = .preferredFont(forTextStyle: .subheadline)
        transfersTitle.textColor = .secondaryLabel
        transfersValue.font = .preferredFont(forTextStyle: .title3)

        totalTitle.text = "Total"
        totalTitle.font = .preferredFont(forTextStyle: .subheadline)
        totalTitle.textColor = .secondaryLabel
        totalValue.font = .preferredFont(forTextStyle: .title3)

        noteIcon.tintColor = .tertiaryLabel
        noteTitleLabel.text = "Note"
        noteTitleLabel.font = .preferredFont(forTextStyle: .headline)
        noteBodyLabel.font = .preferredFont(forTextStyle: .body)
        noteBodyLabel.numberOfLines = 0
    }

    // MARK: Render
    private func render() {
        if let url = vm.transfer.person.avatarURL {
            ImageCache.shared.image(url: url) { [weak self] img in self?.avatar.image = img }
        }
        nameLabel.text = vm.transfer.person.fullName
        emailLabel.text = vm.transfer.person.email ?? "—"

        cardTitleLabel.text = "•••• " + String(vm.transfer.card.number.suffix(4))
        cardSubtitleLabel.text = vm.transfer.card.type.capitalized

        lastTitleLabel.text = "Last Transfer"
        lastSubtitleLabel.text = DateFormatter.pretty.string(from: vm.transfer.lastTransfer)

        transfersValue.text = Self.numberFormatter.string(from: NSNumber(value: vm.transfer.more.numberOfTransfers))
        totalValue.text = Self.numberFormatter.string(from: NSNumber(value: vm.transfer.more.totalTransfer))

        if let note = vm.transfer.note, !note.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            noteBodyLabel.text = note
            noteCard.isHidden = false
        } else {
            noteCard.isHidden = true
        }
        updateStar()
    }

    private func updateStar() {
        navigationItem.rightBarButtonItem?.image =
            UIImage(systemName: vm.isFavorite ? "star.fill" : "star")
    }

    // MARK: Actions
    @objc private func toggleFavorite() {
        vm.toggle()
        updateStar()
    }
}
