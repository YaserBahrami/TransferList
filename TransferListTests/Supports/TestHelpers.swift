//
//  TestHelpers.swift
//  TransferList
//
//  Created by Yaser Bahrami on 20.09.2025.
//

import Foundation
import Combine

@testable import TransferList

enum TestHelpers {

    // MARK: - Optional helpers
    enum TestError: Error { case noValue }

    static func unwrap<T>(_ value: T?, or error: @autoclosure () -> Error = TestError.noValue) throws -> T {
        guard let v = value else { throw error() }
        return v
    }

    // MARK: - First value (Failure == Never) — non-throwing
    static func awaitFirstValue<P: Publisher>(_ p: P) async -> P.Output where P.Failure == Never {
        var it = p.values.makeAsyncIterator()
        return await it.next()!   // safe: cannot throw, value expected by tests
    }

    // MARK: - First value (Failure == Error) — throwing
    static func awaitFirstValue<P: Publisher>(_ p: P) async throws -> P.Output where P.Failure == Error {
        var it = p.values.makeAsyncIterator()
        return try unwrap(try await it.next())
    }

    // MARK: - N values (Failure == Never) — non-throwing
    static func awaitNextValues<P: Publisher>(_ p: P, count: Int) async -> [P.Output] where P.Failure == Never {
        var res: [P.Output] = []
        var it = p.values.makeAsyncIterator()
        for _ in 0..<count {
            if let v = await it.next() { res.append(v) } else { break }
        }
        return res
    }

    // MARK: - N values (Failure == Error) — throwing
    static func awaitNextValues<P: Publisher>(_ p: P, count: Int) async throws -> [P.Output] where P.Failure == Error {
        var res: [P.Output] = []
        var it = p.values.makeAsyncIterator()
        for _ in 0..<count {
            let v = try await it.next()
            if let v { res.append(v) } else { break }
        }
        return res
    }
}
