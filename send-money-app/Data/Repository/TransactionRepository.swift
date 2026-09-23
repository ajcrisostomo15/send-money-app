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
    private let calendar: Calendar
    private let cache: TransactionCacheProtocol
    
    init(apiClient: APIClientProtocol,
         calendar: Calendar = .current,
         cache: TransactionCacheProtocol
    ) {
        self.apiClient = apiClient
        self.calendar = calendar
        self.cache = cache
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
        
        var cached = cache.load()
        cached.insert(transaction, at: 0)
        cache.save(cached)
        return transaction
    }
    
    func fetchTransactions() async throws -> [Transaction] {
        do {
            let endpoint = try TransactionEndpoint.history()
            let _: [TransactionAPIResponse] = try await apiClient.request(
                endpoint,
                responseType: [TransactionAPIResponse].self
            )

            let cached = cache.load()
            return cached
        } catch {
            throw error
        }
    }
}
