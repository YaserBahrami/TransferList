//
//  HomeViewController.swift
//  TransferList
//
//  Created by Yaser Bahrami on 19.09.2025.
//

import UIKit
import Combine

final class HomeViewController: UIViewController, UISearchResultsUpdating {
    private let viewModel: HomeViewModel
    private let favoritesList: TransferListControllable
    private let allList: TransferListControllable

    var onOpenDetails: ((Transfer) -> Void)?

    private let favoritesHeader = UILabel()
    private let allHeader = UILabel()

    private var favoritesContainer = UIView()
    private var allContainer = UIView()
    private var favoritesHeightConstraint: NSLayoutConstraint!

    private var bag = Set<AnyCancellable>()

    // MARK: Init
    init(viewModel: HomeViewModel,
         favoritesList: TransferListControllable,
         allList: TransferListControllable) {
        self.viewModel = viewModel
        self.favoritesList = favoritesList
        self.allList = allList
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Transfers"
        view.backgroundColor = .systemBackground

        configureSearch()
        layout()
        wireModules()
        bindViewModelOutputs()

        // Initial loads
        favoritesList.reload()
        allList.reload()

        // Initial visibility state
        setFavoritesVisible(!viewModel.areFavoritesEmpty(), animated: false)
    }

    // MARK: Search
    private func configureSearch() {
        let sc = UISearchController(searchResultsController: nil)
        sc.obscuresBackgroundDuringPresentation = false
        sc.searchResultsUpdater = self
        navigationItem.searchController = sc
    }

    // MARK: Layout
    private func layout() {
        [favoritesHeader, favoritesContainer, allHeader, allContainer].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        favoritesHeader.text = "Favorites"
        favoritesHeader.font = .preferredFont(forTextStyle: .title3)
        allHeader.text = "All"
        allHeader.font = .preferredFont(forTextStyle: .title3)

        // Embed Favorites (horizontal collection)
        let favVC = favoritesList.viewController
        addChild(favVC)
        favoritesContainer.addSubview(favVC.view)
        favVC.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            favVC.view.leadingAnchor.constraint(equalTo: favoritesContainer.leadingAnchor),
            favVC.view.trailingAnchor.constraint(equalTo: favoritesContainer.trailingAnchor),
            favVC.view.topAnchor.constraint(equalTo: favoritesContainer.topAnchor),
            favVC.view.bottomAnchor.constraint(equalTo: favoritesContainer.bottomAnchor)
        ])
        favVC.didMove(toParent: self)

        // Embed All (table)
        let allVC = allList.viewController
        addChild(allVC)
        allContainer.addSubview(allVC.view)
        allVC.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            allVC.view.leadingAnchor.constraint(equalTo: allContainer.leadingAnchor),
            allVC.view.trailingAnchor.constraint(equalTo: allContainer.trailingAnchor),
            allVC.view.topAnchor.constraint(equalTo: allContainer.topAnchor),
            allVC.view.bottomAnchor.constraint(equalTo: allContainer.bottomAnchor)
        ])
        allVC.didMove(toParent: self)

        let g = view.safeAreaLayoutGuide
        favoritesHeightConstraint = favoritesContainer.heightAnchor.constraint(equalToConstant: 150)

        NSLayoutConstraint.activate([
            favoritesHeader.topAnchor.constraint(equalTo: g.topAnchor, constant: 12),
            favoritesHeader.leadingAnchor.constraint(equalTo: g.leadingAnchor, constant: 16),
            favoritesHeader.trailingAnchor.constraint(lessThanOrEqualTo: g.trailingAnchor, constant: -16),

            favoritesContainer.topAnchor.constraint(equalTo: favoritesHeader.bottomAnchor, constant: 8),
            favoritesContainer.leadingAnchor.constraint(equalTo: g.leadingAnchor),
            favoritesContainer.trailingAnchor.constraint(equalTo: g.trailingAnchor),
            favoritesHeightConstraint,

            allHeader.topAnchor.constraint(equalTo: favoritesContainer.bottomAnchor, constant: 12),
            allHeader.leadingAnchor.constraint(equalTo: g.leadingAnchor, constant: 16),
            allHeader.trailingAnchor.constraint(lessThanOrEqualTo: g.trailingAnchor, constant: -16),

            allContainer.topAnchor.constraint(equalTo: allHeader.bottomAnchor, constant: 8),
            allContainer.leadingAnchor.constraint(equalTo: g.leadingAnchor),
            allContainer.trailingAnchor.constraint(equalTo: g.trailingAnchor),
            allContainer.bottomAnchor.constraint(equalTo: g.bottomAnchor)
        ])
    }

    // MARK: Wiring
    private func wireModules() {
        favoritesList.onSelect = { [weak self] t in self?.onOpenDetails?(t) }
        allList.onSelect = { [weak self] t in self?.onOpenDetails?(t) }
    }

    // MARK: Bind VM → View
    private func bindViewModelOutputs() {
        // Show/hide Favorites section based solely on having any favorite IDs.
        viewModel.favoritesVisibilityPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] visible in
                self?.setFavoritesVisible(visible)
                self?.favoritesList.externalFavoritesDidChange()
                self?.allList.externalFavoritesDidChange()
            }
            .store(in: &bag)

        // Refresh lists whenever favorites change or transfers load.
        viewModel.refreshListsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.favoritesList.externalFavoritesDidChange()
                self?.allList.externalFavoritesDidChange()
            }
            .store(in: &bag)
    }

    private func setFavoritesVisible(_ visible: Bool, animated: Bool = true) {
        favoritesHeader.isHidden = !visible
        favoritesContainer.isHidden = !visible
        favoritesHeightConstraint.constant = visible ? 150 : 0
        let block = { self.view.layoutIfNeeded() }
        animated ? UIView.animate(withDuration: 0.2, animations: block) : block()
    }

    // MARK: UISearchResultsUpdating
    private var searchDebounceCancellable: AnyCancellable?
    
    // MARK: UISearchResultsUpdating
    func updateSearchResults(for searchController: UISearchController) {
        let text = searchController.searchBar.text
        // Debounce 180ms
        searchDebounceCancellable?.cancel()
        searchDebounceCancellable = Just(text)
            .delay(for: .milliseconds(180), scheduler: DispatchQueue.main)
            .sink { [weak self] debounced in
                self?.favoritesList.applySearch(debounced)
                self?.allList.applySearch(debounced)
            }
    }
}
