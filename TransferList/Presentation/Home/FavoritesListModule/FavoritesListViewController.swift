//
//  FavoritesListViewController.swift
//  TransferList
//
//  Created by Yaser Bahrami on 19.09.2025.
//

import UIKit

final class FavoritesListViewController: UIViewController, TransferListControllable, UICollectionViewDelegate {
    var onSelect: ((Transfer) -> Void)?
    
    private let vm: FavoritesListViewModel
    private var collectionView: UICollectionView!
    private typealias DS = UICollectionViewDiffableDataSource<Int, TransferListItemViewModel>
    private var dataSource: DS!
    
    init(viewModel: FavoritesListViewModel) {
        self.vm = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    var viewController: UIViewController { self }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollection()
        vm.onSnapshot = { [weak self] items in self?.apply(items) }
    }
    
    func applySearch(_ text: String?) { vm.setSearch(text) }
    func reload() { vm.reload() }
    func externalFavoritesDidChange() { vm.favoritesChanged() }
    
    private func configureCollection() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 12
        layout.itemSize = CGSize(width: 120, height: 120)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.alwaysBounceHorizontal = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        collectionView.register(FavoriteItemCell.self, forCellWithReuseIdentifier: FavoriteItemCell.reuseID)
        collectionView.delegate = self
        
        dataSource = DS(collectionView: collectionView) { cv, indexPath, item in
            let cell = cv.dequeueReusableCell(withReuseIdentifier: FavoriteItemCell.reuseID, for: indexPath) as! FavoriteItemCell
            cell.configure(with: item)
            return cell
        }
    }
    
    private func apply(_ items: [TransferListItemViewModel]) {
        var snap = NSDiffableDataSourceSnapshot<Int, TransferListItemViewModel>()
        snap.appendSections([0])
        var seen = Set<String>()
        let unique = items.filter { seen.insert($0.id).inserted }
        snap.appendItems(unique)
        dataSource.apply(snap, animatingDifferences: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        onSelect?(item.model)
    }
}

// MARK: - Cell
private final class FavoriteItemCell: UICollectionViewCell {
    static let reuseID = "FavoriteItemCell"
    
    private let avatar = AvatarImageView()
    private let nameLabel = UILabel()
    private let subLabel = UILabel()
    private let vStack = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        avatar.widthAnchor.constraint(equalToConstant: 48).isActive = true
        avatar.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        nameLabel.font = .preferredFont(forTextStyle: .subheadline)
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = 1
        
        subLabel.font = .preferredFont(forTextStyle: .caption2)
        subLabel.textColor = .secondaryLabel
        subLabel.textAlignment = .center
        subLabel.numberOfLines = 1
        
        vStack.axis = .vertical
        vStack.alignment = .center
        vStack.spacing = 6
        vStack.translatesAutoresizingMaskIntoConstraints = false
        vStack.addArrangedSubview(avatar)
        vStack.addArrangedSubview(nameLabel)
        vStack.addArrangedSubview(subLabel)
        
        contentView.addSubview(vStack)
        NSLayoutConstraint.activate([
            vStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            vStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            vStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            vStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        ])
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func configure(with item: TransferListItemViewModel) {
        nameLabel.text = item.title
        subLabel.text  = item.subtitle
        if let url = item.avatarURL {
            ImageCache.shared.image(url: url) { [weak self] img in self?.avatar.image = img }
        } else {
            avatar.image = UIImage(systemName: "person.circle")
        }
    }
}
