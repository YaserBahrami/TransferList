//
//  AllTransfersListViewModel.swift
//  TransferList
//
//  Created by Yaser Bahrami on 19.09.2025.
//

import Foundation
import Combine

final class AllTransfersListViewModel {
    private let getTransfers: GetTransfersPageUseCaseProtocol
    private let isFav: IsFavoriteUseCaseProtocol
    private let favoritesStore: FavoritesStore

    private var items: [Transfer] = []
    private var page = 1
    private var query: String?

    private var bag = Set<AnyCancellable>()
    var onSnapshot: (([TransferListItemViewModel]) -> Void)?

    init(getTransfers: GetTransfersPageUseCaseProtocol,
         isFav: IsFavoriteUseCaseProtocol,
         favoritesStore: FavoritesStore) {
        self.getTransfers = getTransfers
        self.isFav = isFav
        self.favoritesStore = favoritesStore

        favoritesStore.favoritesPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in self?.pushSnapshot(fastPath: true) }
            .store(in: &bag)
    }

    func reload() {
        page = 1
        items.removeAll()
        loadNext()
    }

    func loadNext() {
        getTransfers.execute(page: page)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] new in
                guard let self else { return }
                self.page += 1
                self.items.append(contentsOf: new)

                var dict = [String: Transfer]()
                for t in self.items { dict[t.id] = t }
                self.items = Array(dict.values).sorted { $0.person.fullName < $1.person.fullName }

                self.pushSnapshot(fastPath: false)
            })
            .store(in: &bag)
    }

    func setSearch(_ text: String?) { query = text?.lowercased(); pushSnapshot(fastPath: false) }
    func favoritesChanged() { pushSnapshot(fastPath: true) }

    private func baseFiltered() -> [Transfer] {
        if let q = query, !q.isEmpty {
            return items.filter { $0.person.fullName.lowercased().contains(q) }
        } else {
            return items
        }
    }

    private func pushSnapshot(fastPath: Bool) {
        let src = baseFiltered()
        if fastPath {
            onSnapshot?(src.map(map))
            return
        }
        var seen = Set<String>()
        let unique = src.filter { seen.insert($0.id).inserted }
        onSnapshot?(unique.map(map))
    }

    private func map(_ t: Transfer) -> TransferListItemViewModel {
        .init(
            id: t.id,
            title: t.person.fullName,
            subtitle: TransferFormatter.subtitle(for: t),
            avatarURL: t.person.avatarURL,
            isFavorite: isFav.execute(id: t.id),
            model: t
        )
    }
}
