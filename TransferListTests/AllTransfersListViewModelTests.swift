//
//  AllTransfersListViewModelTests.swift
//  TransferList
//
//  Created by Yaser Bahrami on 20.09.2025.
//

import Testing
import Combine
@testable import TransferList

@Suite("AllTransfersListViewModel")
struct AllTransfersListViewModelTests {

    // Simple async waiter for snapshot arrays.
    @MainActor
    private func awaitSnapshots(_ snapshots: @autoclosure @escaping () -> [[TransferListItemViewModel]],
                                minCount: Int,
                                attempts: Int = 100) async {
        var tries = 0
        while tries < attempts {
            if snapshots().count >= minCount { return }
            tries += 1
            // Allow main-queue deliveries
            await Task.yield()
        }
        Issue.record("Timed out waiting for \(minCount) snapshots, had \(snapshots().count)")
    }

    @MainActor
    @Test func reloadLoadsFirstPageAndMapsItems() async {
        let repo = MockTransferRepository()
        repo.pages[1] = Fixtures.page(count: 3)

        let fav = InMemoryFavoritesStore()
        let vm = AllTransfersListViewModel(
            getTransfers: GetTransfersPageUseCase(repository: repo),
            isFav: IsFavoriteUseCase(store: fav),
            favoritesStore: fav
        )

        var captured: [[TransferListItemViewModel]] = []
        vm.onSnapshot = { captured.append($0) }

        vm.reload()

        // Wait until the first snapshot arrives
        await awaitSnapshots(captured, minCount: 1)

        #expect(!captured.isEmpty)
        let last = captured.last!
        #expect(last.count == 3)
        // Subtitle should be only masked last 4
        #expect(last.first?.subtitle.starts(with: "•••• ") == true)
    }

    @MainActor
    @Test func favoritesChangeUpdatesStarWithoutRebuilding() async {
        let repo = MockTransferRepository()
        repo.pages[1] = Fixtures.page(count: 1, start: 1001)

        let fav = InMemoryFavoritesStore()
        let vm = AllTransfersListViewModel(
            getTransfers: GetTransfersPageUseCase(repository: repo),
            isFav: IsFavoriteUseCase(store: fav),
            favoritesStore: fav
        )

        var snapshots: [[TransferListItemViewModel]] = []
        vm.onSnapshot = { snapshots.append($0) }

        vm.reload()

        // Wait for initial snapshot
        await awaitSnapshots(snapshots, minCount: 1)
        #expect(snapshots.last?.first?.isFavorite == false)

        // Toggle favorite -> expect one more snapshot
        let prevCount = snapshots.count
        let id = Fixtures.transfer(1001).id
        fav.toggleFavorite(id: id)

        // Wait for the next snapshot after the toggle
        await awaitSnapshots(snapshots, minCount: prevCount + 1)
        #expect(snapshots.last?.first?.isFavorite == true)
    }
}
