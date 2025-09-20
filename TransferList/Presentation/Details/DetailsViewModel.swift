//
//  DetailsViewModel.swift
//  TransferList
//
//  Created by Yaser Bahrami on 20.09.2025.
//

import Foundation

final class DetailsViewModel {
    private(set) var transfer: Transfer
    private let toggleFavorite: ToggleFavoriteUseCaseProtocol
    private let isFavoriteUC: IsFavoriteUseCaseProtocol

    var onChanged: (() -> Void)?

    init(transfer: Transfer, toggleFavorite: ToggleFavoriteUseCaseProtocol, isFavorite: IsFavoriteUseCaseProtocol) {
        self.transfer = transfer
        self.toggleFavorite = toggleFavorite
        self.isFavoriteUC = isFavorite
    }

    var isFavorite: Bool { isFavoriteUC.execute(id: transfer.id) }
    func toggle() { _ = toggleFavorite.execute(id: transfer.id); onChanged?() }
}
