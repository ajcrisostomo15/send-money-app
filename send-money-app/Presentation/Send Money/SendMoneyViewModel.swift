//
//  SendMoneyViewModel.swift
//  send-money-app
//
//  Created by Allen Jeffrey Crisostomo on 9/23/26.
//

import Foundation

class SendMoneyViewModel {
    enum NetworkState {
        case idle
        case loading
        case success(Transaction)
        case failure(String)
    }
    
    private let walletStore: WalletStore
    private let transactionRepository: TransactionRepositoryProtocol
    public var onStateChange: ((NetworkState) -> Void)?
    init(walletStore: WalletStore,
         transactionRepository: TransactionRepositoryProtocol
    ) {
        self.walletStore = walletStore
        self.transactionRepository = transactionRepository
    }
    
    func submit(amountText: String) {
        guard let amount = Decimal(string: amountText), amount > 0 else {
            onStateChange?(.failure("Enter an amount greater than ₱0."))
            return
        }

        guard amount < walletStore.balance else {
            onStateChange?(.failure("Amount must be less than your wallet balance."))
            return
        }

        onStateChange?(.loading)

        Task {
            do {
                let transaction = try await transactionRepository.sendMoney(amount: amount)
                walletStore.deduct(amount)
                onStateChange?(.success(transaction))
            } catch {
                onStateChange?(.failure(error.localizedDescription))
            }
        }
    }
}
