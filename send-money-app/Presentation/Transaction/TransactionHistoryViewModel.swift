//
//  TransactionHistoryViewModel.swift
//  send-money-app
//
//  Created by Allen Jeffrey Crisostomo on 9/23/26.
//

import Foundation

class TransactionHistoryViewModel {
    enum NetworkState {
        case idle
        case loading
        case loaded([Transaction])
        case failure(String)
    }

    private let transactionRepository: TransactionRepositoryProtocol

    private(set) var transactions: [Transaction] = []
    var onStateChange: ((NetworkState) -> Void)?

    init(transactionRepository: TransactionRepositoryProtocol) {
        self.transactionRepository = transactionRepository
    }

    func getListOfHistory() {
        transactions = transactionRepository.cachedTransactions()
        onStateChange?(.loaded(transactions))

        Task {
            do {
                transactions = try await transactionRepository.fetchTransactions()
                onStateChange?(.loaded(transactions))
            } catch {
                onStateChange?(.failure(error.localizedDescription))
            }
        }
    }
}
