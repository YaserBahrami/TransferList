//
//  AppDIContainer.swift
//  TransferList
//
//  Created by Yaser Bahrami on 20.09.2025.
//

import UIKit

final class AppDIContainer {

    // Core
    private lazy var networkManager: NetworkManagerProtocol = NetworkManager()

    // Favorites store (shared)
    private lazy var favoritesStore: FavoritesStore = UserDefaultsFavoritesStore()

    // Repository
    private lazy var transferRepository: TransferRepository =
        TransferRepositoryImpl(network: networkManager, favorites: favoritesStore)

    // Use cases (protocol-typed)
    private lazy var getTransfersPageUC: GetTransfersPageUseCaseProtocol =
        GetTransfersPageUseCase(repository: transferRepository)
    private lazy var getAllLoadedUC: GetAllLoadedTransfersUseCaseProtocol =
        GetAllLoadedTransfersUseCase(repository: transferRepository)
    private lazy var observeLoadedUC: ObserveLoadedTransfersUseCaseProtocol =
        ObserveLoadedTransfersUseCase(repository: transferRepository)
    private lazy var isFavoriteUC: IsFavoriteUseCaseProtocol =
        IsFavoriteUseCase(store: favoritesStore)
    private lazy var toggleFavoriteUC: ToggleFavoriteUseCaseProtocol =
        ToggleFavoriteUseCase(store: favoritesStore)

    func makeRoot(window: UIWindow) -> AppCoordinator {
        AppCoordinator(window: window, container: self)
    }

    func makeHome() -> UIViewController {
        let homeVM = HomeViewModel(
            favoritesStore: favoritesStore,
            getAllLoaded: getAllLoadedUC,
            observeLoaded: observeLoadedUC
        )

        let allVM = AllTransfersListViewModel(
            getTransfers: getTransfersPageUC,
            isFav: isFavoriteUC,
            favoritesStore: favoritesStore
        )
        let allVC = AllTransfersListViewController(viewModel: allVM)

        let favVM = FavoritesListViewModel(
            observeLoaded: observeLoadedUC,
            favoritesStore: favoritesStore,
            isFav: isFavoriteUC
        )
        let favVC = FavoritesListViewController(viewModel: favVM)

        return HomeViewController(
            viewModel: homeVM,
            favoritesList: favVC,
            allList: allVC
        )
    }

    func makeDetails(for transfer: Transfer) -> UIViewController {
        let vm = DetailsViewModel(
            transfer: transfer,
            toggleFavorite: toggleFavoriteUC,
            isFavorite: isFavoriteUC
        )
        return DetailsViewController(viewModel: vm)
    }
}
