//
//  TransferDTO.swift
//  TransferList
//
//  Created by Yaser Bahrami on 20.09.2025.
//

import Foundation

struct TransferDTO: Codable {
    struct PersonDTO: Codable {
        let full_name: String
        let email: String?
        let avatar: String?
    }
    struct CardDTO: Codable {
        let card_number: String
        let card_type: String
    }
    struct MoreDTO: Codable {
        let number_of_transfers: Int
        let total_transfer: Int
    }
    let person: PersonDTO
    let card: CardDTO
    let last_transfer: String
    let note: String?
    let more_info: MoreDTO
}

extension TransferDTO {
    func toEntity() -> Transfer {
        let id = card.card_number
        return Transfer(
            id: id,
            person: Person(fullName: person.full_name, email: person.email, avatarURL: URL(string: person.avatar ?? "")),
            card: Card(number: card.card_number, type: card.card_type),
            lastTransfer: DateFormatter.iso8601Z.date(from: last_transfer) ?? Date(),
            note: note,
            more: MoreInfo(numberOfTransfers: more_info.number_of_transfers, totalTransfer: more_info.total_transfer)
        )
    }
}
