//
//  GetTransfersPageUseCase.swift
//  TransferList
//
//  Created by Yaser Bahrami on 20.09.2025.
//

import Combine

final class GetTransfersPageUseCase: GetTransfersPageUseCaseProtocol {
    private let repository: TransferRepository
    init(repository: TransferRepository) { self.repository = repository }

    func execute(page: Int) -> AnyPublisher<[Transfer], Error> {
        repository.fetchTransfers(page: page)
    }
}
