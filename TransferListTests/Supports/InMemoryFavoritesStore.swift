//
//  InMemoryFavoritesStore.swift
//  TransferList
//
//  Created by Yaser Bahrami on 20.09.2025.
//

import Foundation
import Combine

@testable import TransferList

final class InMemoryFavoritesStore: FavoritesStore {
    private let q = DispatchQueue(label: "fav.store.test.serial")
    private var ids: Set<String> = []
    private let subject = CurrentValueSubject<Set<String>, Never>([])

    var favoritesPublisher: AnyPublisher<Set<String>, Never> { subject.eraseToAnyPublisher() }

    func isFavorite(id: String) -> Bool { q.sync { ids.contains(id) } }
    func allFavorites() -> Set<String> { q.sync { ids } }

    @discardableResult
    func toggleFavorite(id: String) -> Bool {
        q.sync {
            if !ids.insert(id).inserted { ids.remove(id) }
            subject.send(ids)
            return ids.contains(id)
        }
    }

    // Test helper
    func setFavorites(_ set: Set<String>) {
        q.sync { ids = set; subject.send(ids) }
    }
}
