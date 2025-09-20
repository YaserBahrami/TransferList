//
//  RepositoryTests.swift
//  TransferList
//
//  Created by Yaser Bahrami on 20.09.2025.
//

import Testing
import Combine
@testable import TransferList

@Suite("TransferRepository")
struct TransferRepositoryTests {
    @Test func fetchMergesIntoLoadedAndPublishes() async {
        let repo = MockTransferRepository()
        repo.pages[1] = Fixtures.page(count: 2, start: 1)
        repo.pages[2] = Fixtures.page(count: 2, start: 3)
        
        // page 1
        let p1 = try? await repo.fetchTransfers(page: 1).values.first(where: { _ in true })
        #expect(p1?.count == 2)
        #expect(repo.getAllLoaded().count == 2)
        
        // page 2
        let p2 = try? await repo.fetchTransfers(page: 2).values.first(where: { _ in true })
        #expect(p2?.count == 2)
        #expect(repo.getAllLoaded().count == 4)
        
        // loadedPublisher emits combined cache
        let emitted = await TestHelpers.awaitFirstValue(repo.loadedPublisher)
        #expect(emitted.count == 4)
    }
}
