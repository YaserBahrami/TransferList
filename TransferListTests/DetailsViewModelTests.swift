//
//  DetailsViewModelTests.swift
//  TransferList
//
//  Created by Yaser Bahrami on 20.09.2025.
//

import Testing
@testable import TransferList

@Suite("DetailsViewModel")
struct DetailsViewModelTests {
    @Test func toggleChangesFavoriteStateAndInvokesCallback() async {
        let t = Fixtures.transfer(10)
        let store = InMemoryFavoritesStore()
        let vm = DetailsViewModel(
            transfer: t,
            toggleFavorite: ToggleFavoriteUseCase(store: store),
            isFavorite: IsFavoriteUseCase(store: store)
        )

        #expect(vm.isFavorite == false)

        var called = false
        vm.onChanged = { called = true }

        vm.toggle()
        #expect(vm.isFavorite == true)
        #expect(called == true)
    }
}
