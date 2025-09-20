//
//  ObserveLoadedTransfersUseCase.swift
//  TransferList
//
//  Created by Yaser Bahrami on 20.09.2025.
//

import Combine

final class ObserveLoadedTransfersUseCase: ObserveLoadedTransfersUseCaseProtocol {
    private let repository: TransferRepository
    init(repository: TransferRepository) { self.repository = repository }
    func publisher() -> AnyPublisher<[Transfer], Never> { repository.loadedPublisher }
}
