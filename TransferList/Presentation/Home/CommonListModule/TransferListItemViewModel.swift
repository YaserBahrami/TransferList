//
//  TransferListItemViewModel.swift
//  TransferList
//
//  Created by Yaser Bahrami on 20.09.2025.
//

import Foundation

struct TransferListItemViewModel: Hashable {
    let id: String
    let title: String
    let subtitle: String
    let avatarURL: URL?
    let isFavorite: Bool
    let model: Transfer
}
