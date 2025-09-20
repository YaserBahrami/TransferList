//
//  TransferFormatterTests.swift
//  TransferList
//
//  Created by Yaser Bahrami on 20.09.2025.
//

import Testing
@testable import TransferList

@Suite("TransferFormatter")
struct TransferFormatterTests {
    @Test func subtitleShowsOnlyMaskedLast4() async {
        let t = Fixtures.transfer(42)
        let s = TransferFormatter.subtitle(for: t)
        #expect(s == "•••• 0042")
    }
}
