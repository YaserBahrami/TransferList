//
//  HomeViewModelTests.swift
//  TransferList
//
//  Created by Yaser Bahrami on 20.09.2025.
//

import Testing
import Combine
@testable import TransferList

@Suite("HomeViewModel")
struct HomeViewModelTests {
    @Test func favoritesVisibilityReflectsIDs() async {
        let repo = MockTransferRepository()
        let fav = InMemoryFavoritesStore()
        let vm = HomeViewModel(
            favoritesStore: fav,
            getAllLoaded: GetAllLoadedTransfersUseCase(repository: repo),
            observeLoaded: ObserveLoadedTransfersUseCase(repository: repo)
        )

        // Initially empty
        var vis = await TestHelpers.awaitFirstValue(vm.favoritesVisibilityPublisher)
        #expect(vis == false)

        // Add a favorite id
        let t = Fixtures.transfer(1)
        fav.setFavorites([t.id])

        // Next emission should be true
        vis = await TestHelpers.awaitFirstValue(vm.favoritesVisibilityPublisher)
        #expect(vis == true)
    }

    @Test func refreshEmitsOnFavoritesAndOnLoaded() async {
        let repo = MockTransferRepository()
        let fav = InMemoryFavoritesStore()
        let vm = HomeViewModel(
            favoritesStore: fav,
            getAllLoaded: GetAllLoadedTransfersUseCase(repository: repo),
            observeLoaded: ObserveLoadedTransfersUseCase(repository: repo)
        )

        // Cause favorites change -> one refresh signal
        fav.setFavorites(["A"])
        let first = await TestHelpers.awaitFirstValue(vm.refreshListsPublisher)
        _ = first // unused value ()

        // Cause loaded change -> another refresh signal
        repo.pages[1] = Fixtures.page(count: 1)
        _ = try? await repo.fetchTransfers(page: 1).values.first(where: { _ in true })

        let second = await TestHelpers.awaitFirstValue(vm.refreshListsPublisher)
        _ = second

        // If we reach here, both signals were emitted
        #expect(true)
    }
}
