//
//  UseCaseProtocols.swift
//  TransferList
//
//  Created by Yaser Bahrami on 20.09.2025.
//

import Combine
import Foundation

protocol GetTransfersPageUseCaseProtocol {
    func execute(page: Int) -> AnyPublisher<[Transfer], Error>
}

protocol GetAllLoadedTransfersUseCaseProtocol {
    func execute() -> [Transfer]
}

protocol ObserveLoadedTransfersUseCaseProtocol {
    func publisher() -> AnyPublisher<[Transfer], Never>
}

protocol IsFavoriteUseCaseProtocol {
    func execute(id: String) -> Bool
}

protocol ToggleFavoriteUseCaseProtocol {
    @discardableResult func execute(id: String) -> Bool
}
