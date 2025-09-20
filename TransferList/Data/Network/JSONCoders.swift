//
//  JSONCoders.swift
//  TransferList
//
//  Created by Yaser Bahrami on 20.09.2025.
//

import Foundation

extension JSONDecoder {
    static let transferDecoder: JSONDecoder = {
        let d = JSONDecoder()
        d.dateDecodingStrategy = .formatted(DateFormatter.iso8601Z)
        return d
    }()
}

extension DateFormatter {
    static let iso8601Z: DateFormatter = {
        let f = DateFormatter()
        f.locale = .init(identifier: "en_US_POSIX")
        f.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        f.timeZone = .init(secondsFromGMT: 0)
        return f
    }()
    static let pretty: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .medium; f.timeStyle = .short
        return f
    }()
}
