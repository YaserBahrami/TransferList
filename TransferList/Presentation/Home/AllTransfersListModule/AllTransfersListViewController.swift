//
//  AllTransfersListViewController.swift
//  TransferList
//
//  Created by Yaser Bahrami on 19.09.2025.
//

import UIKit

final class AllTransfersListViewController: UIViewController, TransferListControllable, UITableViewDelegate {
    var onSelect: ((Transfer) -> Void)?

    private let vm: AllTransfersListViewModel
    private let table = UITableView(frame: .zero, style: .plain)
    private lazy var ds = makeDS()

    init(viewModel: AllTransfersListViewModel) { self.vm = viewModel; super.init(nibName: nil, bundle: nil) }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    var viewController: UIViewController { self }

    override func viewDidLoad() {
        super.viewDidLoad()
        table.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(table)
        NSLayoutConstraint.activate([
            table.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            table.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            table.topAnchor.constraint(equalTo: view.topAnchor),
            table.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        table.register(TransferCell.self, forCellReuseIdentifier: TransferCell.reuseID)
        table.delegate = self
        vm.onSnapshot = { [weak self] items in self?.apply(items) }
    }

    func applySearch(_ text: String?) { vm.setSearch(text) }
    func reload() { vm.reload() }
    func externalFavoritesDidChange() { vm.favoritesChanged() }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.bounds.height * 1.5 {
            vm.loadNext()
        }
    }

    private func makeDS() -> UITableViewDiffableDataSource<Int, TransferListItemViewModel> {
        UITableViewDiffableDataSource(tableView: table) { [weak self] table, _, item in
            let cell = table.dequeueReusableCell(withIdentifier: TransferCell.reuseID) as! TransferCell
            cell.configure(with: item)
            return cell
        }
    }

    private func apply(_ items: [TransferListItemViewModel]) {
        var s = NSDiffableDataSourceSnapshot<Int, TransferListItemViewModel>()
        s.appendSections([0]); s.appendItems(items)
        ds.apply(s, animatingDifferences: true)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = ds.itemIdentifier(for: indexPath) else { return }
        tableView.deselectRow(at: indexPath, animated: true)
        onSelect?(item.model)
    }
}
