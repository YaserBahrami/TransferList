//
//  GetAllLoadedTransfersUseCase.swift
//  TransferList
//
//  Created by Yaser Bahrami on 20.09.2025.
//

final class GetAllLoadedTransfersUseCase: GetAllLoadedTransfersUseCaseProtocol {
    private let repository: TransferRepository
    init(repository: TransferRepository) { self.repository = repository }
    func execute() -> [Transfer] { repository.getAllLoaded() }
}
