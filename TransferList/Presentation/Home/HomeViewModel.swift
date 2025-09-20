//
//  HomeViewModel.swift
//  TransferList
//
//  Created by Yaser Bahrami on 19.09.2025.
//

import Foundation
import Combine

final class HomeViewModel {
    // MARK: Dependencies
    private let favoritesStore: FavoritesStore
    private let getAllLoaded: GetAllLoadedTransfersUseCaseProtocol
    private let observeLoaded: ObserveLoadedTransfersUseCaseProtocol

    // MARK: Outputs
    let favoritesVisibilityPublisher: AnyPublisher<Bool, Never>

    let refreshListsPublisher: AnyPublisher<Void, Never>

    var favoritesPublisher: AnyPublisher<Set<String>, Never> { favoritesStore.favoritesPublisher }
    var loadedPublisher: AnyPublisher<[Transfer], Never> { observeLoaded.publisher() }

    // MARK: Init
    init(favoritesStore: FavoritesStore,
         getAllLoaded: GetAllLoadedTransfersUseCaseProtocol,
         observeLoaded: ObserveLoadedTransfersUseCaseProtocol) {
        self.favoritesStore = favoritesStore
        self.getAllLoaded = getAllLoaded
        self.observeLoaded = observeLoaded

        self.favoritesVisibilityPublisher = favoritesStore
            .favoritesPublisher
            .map { !$0.isEmpty }
            .removeDuplicates()
            .eraseToAnyPublisher()

        let favs = favoritesStore.favoritesPublisher.map { _ in () }
        let loaded = observeLoaded.publisher().map { _ in () }
        self.refreshListsPublisher = favs
            .merge(with: loaded)
            .eraseToAnyPublisher()
    }

    // MARK: Queries / Helpers
    func areFavoritesEmpty() -> Bool {
        getAllLoaded.execute().allSatisfy { !favoritesStore.isFavorite(id: $0.id) }
    }

    func toggleFavorite(id: String) {
        _ = favoritesStore.toggleFavorite(id: id)
    }
}
