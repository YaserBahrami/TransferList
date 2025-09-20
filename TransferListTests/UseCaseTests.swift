//
//  UseCaseTests.swift
//  TransferList
//
//  Created by Yaser Bahrami on 20.09.2025.
//

import Testing
import Combine
@testable import TransferList

@Suite("UseCases")
struct UseCaseTests {
    @Test func getTransfersPagePublishes() async throws {
        let repo = MockTransferRepository()
        repo.pages[1] = Fixtures.page(count: 3)
        let uc = GetTransfersPageUseCase(repository: repo) as GetTransfersPageUseCaseProtocol

        let values = try await TestHelpers.awaitFirstValue(uc.execute(page: 1))
        #expect(values.count == 3)
    }

    @Test func getAllLoadedReflectsRepositoryCache() async {
        let repo = MockTransferRepository()
        repo.pages[1] = Fixtures.page(count: 1)
        _ = try? await repo.fetchTransfers(page: 1).values.first(where: { _ in true })
        let uc = GetAllLoadedTransfersUseCase(repository: repo) as GetAllLoadedTransfersUseCaseProtocol

        #expect(uc.execute().count == 1)
    }

    @Test func observeLoadedStreamsChanges() async {
        let repo = MockTransferRepository()
        let obs = ObserveLoadedTransfersUseCase(repository: repo) as ObserveLoadedTransfersUseCaseProtocol

        // Trigger a change
        repo.pages[1] = Fixtures.page(count: 2)
        _ = try? await repo.fetchTransfers(page: 1).values.first(where: { _ in true })

        let received = await TestHelpers.awaitFirstValue(obs.publisher())
        #expect(received.count == 2)
    }
}
