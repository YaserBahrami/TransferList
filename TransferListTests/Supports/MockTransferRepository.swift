//
//  MockTransferRepository.swift
//  TransferList
//
//  Created by Yaser Bahrami on 20.09.2025.
//

import Foundation
import Combine

@testable import TransferList

final class MockTransferRepository: TransferRepository {
    private let subject = CurrentValueSubject<[Transfer], Never>([])
    private(set) var loaded: [Transfer] = []

    // Configure pages by page number
    var pages: [Int: [Transfer]] = [:]
    var fetchError: Error?

    var loadedPublisher: AnyPublisher<[Transfer], Never> { subject.eraseToAnyPublisher() }

    func fetchTransfers(page: Int) -> AnyPublisher<[Transfer], Error> {
        if let e = fetchError { return Fail(error: e).eraseToAnyPublisher() }
        let result = pages[page] ?? []
        mergeLoaded(result)
        return Just(result).setFailureType(to: Error.self).eraseToAnyPublisher()
    }

    func getAllLoaded() -> [Transfer] { loaded }

    private func mergeLoaded(_ newItems: [Transfer]) {
        var dict = Dictionary(uniqueKeysWithValues: loaded.map { ($0.id, $0) })
        for i in newItems { dict[i.id] = i }
        loaded = Array(dict.values).sorted { $0.person.fullName < $1.person.fullName }
        subject.send(loaded)
    }
}
