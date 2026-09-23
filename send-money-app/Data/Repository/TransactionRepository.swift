//
//  TransactionRepository.swift
//  send-money-app
//
//  Created by Allen Jeffrey Crisostomo on 9/23/26.
//

import Foundation

protocol TransactionRepositoryProtocol {
    func sendMoney(amount: Decimal) async throws -> Transaction
    func fetchTransactions() async throws -> [Transaction]
}

class TransactionRepository: TransactionRepositoryProtocol {
    private let apiClient: APIClientProtocol
    
    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }
    func sendMoney(amount: Decimal) async throws -> Transaction {
        let endpoint = try TransactionEndpoint.send(amount: amount)
        let response: TransactionAPIResponse = try await apiClient.request(
            endpoint,
            responseType: TransactionAPIResponse.self
        )

        let transaction = Transaction(
            id: response.id,
            amount: amount,
            date: Date(),
            recipient: "Demo Recipient"
        )
        
        return transaction
    }
    
    func fetchTransactions() async throws -> [Transaction] {
        do {
            let endpoint = try await TransactionEndpoint.history()
            let response: [TransactionAPIResponse] = try await apiClient.request(
                endpoint,
                responseType: [TransactionAPIResponse].self
            )

            let transactions = response.prefix(10).map { item in
                Transaction(
                    id: item.id,
                    amount: Decimal(item.id * 10),
                    date: calendar.date(byAdding: .day, value: -item.id, to: Date()) ?? Date(),
                    recipient: "Recipient \(item.userId)"
                )
            }

            let result = Array(transactions)
            return result
        } catch {
            throw error
        }
    }
}
