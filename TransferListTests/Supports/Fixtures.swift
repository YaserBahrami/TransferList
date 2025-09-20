//
//  Fixtures.swift
//  TransferList
//
//  Created by Yaser Bahrami on 20.09.2025.
//

import Foundation

@testable import TransferList

enum Fixtures {
    static func person(_ n: Int = 1) -> Person {
        Person(fullName: "User \(n)",
               email: n % 2 == 0 ? "user\(n)@mail.com" : nil,
               avatarURL: URL(string: "https://example.com/a\(n).png"))
    }

    static func card(_ n: Int = 1) -> Card {
        Card(number: "999988887777\(String(format: "%04d", n))",
             type: "visa")
    }

    static func transfer(_ n: Int = 1,
                         date: Date = Date(timeIntervalSince1970: 1_700_000_000),
                         note: String? = nil,
                         transfers: Int = 10,
                         total: Int = 1234) -> Transfer {
        Transfer(
            id: "999988887777\(String(format: "%04d", n))",
            person: person(n),
            card: card(n),
            lastTransfer: date,
            note: note,
            more: MoreInfo(numberOfTransfers: transfers, totalTransfer: total)
        )
    }

    static func page(count: Int, start: Int = 1) -> [Transfer] {
        (0..<count).map { transfer(start + $0) }
    }
}
