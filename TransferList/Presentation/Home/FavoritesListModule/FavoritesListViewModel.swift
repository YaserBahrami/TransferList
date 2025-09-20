//
//  FavoritesListViewModel.swift
//  TransferList
//
//  Created by Yaser Bahrami on 19.09.2025.
//

import Foundation
import Combine

final class FavoritesListViewModel {
    private let observeLoaded: ObserveLoadedTransfersUseCaseProtocol
    private let favoritesStore: FavoritesStore
    private let isFav: IsFavoriteUseCaseProtocol

    private var bag = Set<AnyCancellable>()
    private var query: String?

    // Cache last values so applySearch() can recompute
    private var lastLoaded: [Transfer] = []
    private var lastFavs: Set<String> = []

    var onSnapshot: (([TransferListItemViewModel]) -> Void)?

    init(observeLoaded: ObserveLoadedTransfersUseCaseProtocol,
         favoritesStore: FavoritesStore,
         isFav: IsFavoriteUseCaseProtocol) {
        self.observeLoaded = observeLoaded
        self.favoritesStore = favoritesStore
        self.isFav = isFav
        bind()
    }

    private func bind() {
        observeLoaded.publisher()
            .combineLatest(favoritesStore.favoritesPublisher)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] loaded, favs in
                guard let self else { return }
                self.lastLoaded = loaded
                self.lastFavs = favs
                self.push()
            }
            .store(in: &bag)
    }

    func reload() { /* no-op: reactive */ }
    func favoritesChanged() { push() }
    func setSearch(_ text: String?) { query = text?.lowercased(); push() }

    private func push() {
        let favorites = lastLoaded.filter { lastFavs.contains($0.id) }
        let filtered: [Transfer]
        if let q = query, !q.isEmpty {
            filtered = favorites.filter { $0.person.fullName.lowercased().contains(q) }
        } else {
            filtered = favorites
        }

        var seen = Set<String>()
        let uniq = filtered.filter { seen.insert($0.id).inserted }
        let viewModels = uniq.map { t in
            TransferListItemViewModel(
                id: t.id,
                title: t.person.fullName,
                subtitle: TransferFormatter.subtitle(for: t),
                avatarURL: t.person.avatarURL,
                isFavorite: true,
                model: t
            )
        }
        onSnapshot?(viewModels)
    }
}
