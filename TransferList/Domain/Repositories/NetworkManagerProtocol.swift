//
//  NetworkManagerProtocol.swift
//  TransferList
//
//  Created by Yaser Bahrami on 20.09.2025.
//

import Combine

protocol NetworkManagerProtocol {
    func request<T: Decodable>(_ type: T.Type, _ endpoint: Endpoint) -> AnyPublisher<T, Error>
}
