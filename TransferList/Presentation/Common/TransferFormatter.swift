//
//  TransferFormatter.swift
//  TransferList
//
//  Created by Yaser Bahrami on 20.09.2025.
//

enum TransferFormatter {
    /// Generates the subtitle string shown in lists:
    /// "•••• 1234"
    static func subtitle(for transfer: Transfer) -> String {
        "•••• \(transfer.card.number.suffix(4))"
    }
}
