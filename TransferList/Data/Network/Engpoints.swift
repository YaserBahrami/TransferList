//
//  Engpoints.swift
//  TransferList
//
//  Created by Yaser Bahrami on 20.09.2025.
//

import Foundation

import Foundation

/// API routes with safe URL composition.
enum Endpoint {
    case transferList(page: Int)

    var method: HTTPMethod {
        switch self {
        case .transferList: return .get
        }
    }

    /// Path without a leading slash.
    var path: String {
        switch self {
        case .transferList:
            return "transfer-list"
        }
    }

    var queryItems: [URLQueryItem] {
        switch self {
        case .transferList(let page):
            return [URLQueryItem(name: "page", value: String(page))]
        }
    }

    /// Build a fully-qualified URL from AppConfig.baseURL
    func url(baseURL: URL = AppConfig.baseURL) -> URL {
        var url = baseURL
        url.appendPathComponent(path, conformingTo: .url)

        var comps = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        let items = queryItems
        if !items.isEmpty { comps.queryItems = items }

        guard let final = comps.url else { preconditionFailure("Invalid URL for \(self)") }
        return final
    }
}
