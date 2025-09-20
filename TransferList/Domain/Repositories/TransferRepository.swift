//
//  TransferRepository.swift
//  TransferList
//
//  Created by Yaser Bahrami on 20.09.2025.
//


import Foundation
import Combine

protocol TransferRepository {
    /// Fetch a page from the backend.
    func fetchTransfers(page: Int) -> AnyPublisher<[Transfer], Error>

    /// Returns the cache of all loaded transfers so far.
    func getAllLoaded() -> [Transfer]

    /// Publishes whenever loaded cache changes.
    var loadedPublisher: AnyPublisher<[Transfer], Never> { get }
}
