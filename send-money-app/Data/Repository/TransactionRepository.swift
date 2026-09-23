//
//  TransactionRepository.swift
//  send-money-app
//
//  Created by Allen Jeffrey Crisostomo on 9/23/26.
//

import Foundation

protocol TransactionRepositoryProtocol {
    func sendMoney(amount: Decimal) async throws -> Transaction
}

class TransactionRepository: TransactionRepositoryProtocol {
    private let apiClient: APIClientProtocol
    
    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }
    func sendMoney(amount: Decimal) async throws -> Transaction {
        let endpoint = try TransactionEndpoint.send(amount: amount)
        let response: Transaction = try await apiClient.request(
            endpoint,
            responseType: Transaction.self
        )

        let transaction = Transaction(
            id: response.id,
            amount: amount,
            date: Date(),
            recipient: "Demo Recipient"
        )
        
        return transaction
    }
}
