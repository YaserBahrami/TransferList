//
//  ToggleFavoriteUseCase.swift
//  TransferList
//
//  Created by Yaser Bahrami on 20.09.2025.
//

import Foundation

final class ToggleFavoriteUseCase: ToggleFavoriteUseCaseProtocol {
    private let store: FavoritesStore
    init(store: FavoritesStore) { self.store = store }
    @discardableResult
    func execute(id: String) -> Bool { store.toggleFavorite(id: id) }
}

