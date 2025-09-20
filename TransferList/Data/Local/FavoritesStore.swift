//
//  FavoritesStore.swift
//  TransferList
//
//  Created by Yaser Bahrami on 20.09.2025.
//

import Foundation
import Combine

protocol FavoritesReadable {
    func isFavorite(id: String) -> Bool
    func allFavorites() -> Set<String>
    var favoritesPublisher: AnyPublisher<Set<String>, Never> { get }
}
protocol FavoritesWritable {
    @discardableResult func toggleFavorite(id: String) -> Bool
}
typealias FavoritesStore = FavoritesReadable & FavoritesWritable

final class UserDefaultsFavoritesStore: FavoritesStore {
    private let key = "favorites.ids"
    private let ud: UserDefaults
    private let q = DispatchQueue(label: "favorites.store.serial")

    private var ids: Set<String> {
        didSet {
            ud.set(Array(ids), forKey: key)
            subject.send(ids)
        }
    }

    private let subject: CurrentValueSubject<Set<String>, Never>
    var favoritesPublisher: AnyPublisher<Set<String>, Never> { subject.eraseToAnyPublisher() }

    init(userDefaults: UserDefaults = .standard) {
        self.ud = userDefaults
        let initial = Set(userDefaults.array(forKey: key) as? [String] ?? [])
        self.ids = initial
        self.subject = .init(initial)
    }

    func isFavorite(id: String) -> Bool { q.sync { ids.contains(id) } }
    func allFavorites() -> Set<String> { q.sync { ids } }

    @discardableResult
    func toggleFavorite(id: String) -> Bool {
        q.sync {
            if !ids.insert(id).inserted { ids.remove(id) }
            // didSet persists + publishes
            return ids.contains(id)
        }
    }
}
