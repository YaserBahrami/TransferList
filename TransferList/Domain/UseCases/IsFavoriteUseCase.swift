//
//  IsFavoriteUseCase.swift
//  TransferList
//
//  Created by Yaser Bahrami on 20.09.2025.
//

final class IsFavoriteUseCase: IsFavoriteUseCaseProtocol {
    private let store: FavoritesStore
    init(store: FavoritesStore) { self.store = store }
    func execute(id: String) -> Bool { store.isFavorite(id: id) }
}

