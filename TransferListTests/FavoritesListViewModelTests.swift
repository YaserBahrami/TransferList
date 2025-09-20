//
//  FavoritesListViewModelTests.swift
//  TransferList
//
//  Created by Yaser Bahrami on 20.09.2025.
//

import Testing
import Combine
@testable import TransferList

@Suite("FavoritesListViewModel")
struct FavoritesListViewModelTests {
    @MainActor
    @Test func showsOnlyFavoriteTransfersAndRespectsSearch() async {
        let repo = MockTransferRepository()
        let arr = [
            Fixtures.transfer(1),
            Fixtures.transfer(2),
            Fixtures.transfer(3)
        ]
        repo.pages[1] = arr
        _ = try? await repo.fetchTransfers(page: 1).values.first(where: { _ in true })

        let fav = InMemoryFavoritesStore()
        fav.setFavorites([arr[0].id, arr[2].id])

        let vm = FavoritesListViewModel(
            observeLoaded: ObserveLoadedTransfersUseCase(repository: repo),
            favoritesStore: fav,
            isFav: IsFavoriteUseCase(store: fav)
        )

        var snaps: [[TransferListItemViewModel]] = []
        vm.onSnapshot = { snaps.append($0) }

        // Initial emission with two favorites
        await Task.yield()
        #expect(snaps.last?.count == 2)

        // Apply search that excludes first item (search by name)
        vm.setSearch("User 3")
        await Task.yield()
        #expect(snaps.last?.count == 1)
        #expect(snaps.last?.first?.title == "User 3")
    }
}
