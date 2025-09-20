//
//  TransferRepositoryImpl.swift
//  TransferList
//
//  Created by Yaser Bahrami on 20.09.2025.
//

import Foundation
import Combine

final class TransferRepositoryImpl: TransferRepository {
    private let network: NetworkManagerProtocol
    private let favorites: FavoritesStore

    private var loaded: [Transfer] = [] {
        didSet { subject.send(loaded) }
    }
    private let subject = CurrentValueSubject<[Transfer], Never>([])
    var loadedPublisher: AnyPublisher<[Transfer], Never> { subject.eraseToAnyPublisher() }

    private var bag = Set<AnyCancellable>()

    init(network: NetworkManagerProtocol, favorites: FavoritesStore) {
        self.network = network
        self.favorites = favorites
    }

    func fetchTransfers(page: Int) -> AnyPublisher<[Transfer], Error> {
        network.request([TransferDTO].self, .transferList(page: page))
            .map { $0.map { $0.toEntity() } }
            .handleEvents(receiveOutput: { [weak self] items in
                self?.mergeLoaded(items)
            })
            .eraseToAnyPublisher()
    }

    func getAllLoaded() -> [Transfer] { loaded }

    private func mergeLoaded(_ newItems: [Transfer]) {
        var dict = Dictionary(uniqueKeysWithValues: loaded.map { ($0.id, $0) })
        for i in newItems { dict[i.id] = i }
        loaded = Array(dict.values).sorted { $0.person.fullName < $1.person.fullName }
    }
}
