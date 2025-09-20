//
//  TransferEntities.swift
//  TransferList
//
//  Created by Yaser Bahrami on 20.09.2025.
//

import Foundation

struct Person: Hashable {
    let fullName: String
    let email: String?
    let avatarURL: URL?
}

struct Card: Hashable {
    let number: String
    let type: String
}

struct MoreInfo: Hashable {
    let numberOfTransfers: Int
    let totalTransfer: Int
}

struct Transfer: Hashable {
    let id: String
    let person: Person
    let card: Card
    let lastTransfer: Date
    let note: String?
    let more: MoreInfo
}
