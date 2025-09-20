//
//  NetworkManager.swift
//  TransferList
//
//  Created by Yaser Bahrami on 20.09.2025.
//

import Foundation
import Combine


final class NetworkManager: NetworkManagerProtocol {
    private let session: URLSession
    private let decoder: JSONDecoder

    init(session: URLSession = .shared) {
        self.session = session

        // Configure once; reuse everywhere
        let dec = JSONDecoder()
        dec.dateDecodingStrategy = .iso8601
        self.decoder = dec
    }

    func request<T: Decodable>(_ type: T.Type, _ endpoint: Endpoint) -> AnyPublisher<T, Error> {
        var req = URLRequest(url: endpoint.url())
        req.httpMethod = endpoint.method.rawValue
        req.setValue("application/json", forHTTPHeaderField: "Accept")

        return session.dataTaskPublisher(for: req)
            .tryMap { result -> Data in
                if let http = result.response as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
                    throw URLError(.badServerResponse)
                }
                return result.data
            }
            .decode(type: T.self, decoder: decoder)
            // 🚫 Don’t hop to main thread here; do it at the UI boundary (VM/VC).
            .eraseToAnyPublisher()
    }
}
