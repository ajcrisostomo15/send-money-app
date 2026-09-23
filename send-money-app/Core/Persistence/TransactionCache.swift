//
//  Cache.swift
//  send-money-app
//
//  Created by Allen Jeffrey Crisostomo on 9/23/26.
//

import Foundation

protocol TransactionCacheProtocol {
    func save(_ transactions: [Transaction])
    func load() -> [Transaction]
    func clear()
}

class TransactionCache: TransactionCacheProtocol {
    private let defaults: UserDefaults
    private let key = "cached.transactions"

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func save(_ transactions: [Transaction]) {
        guard let data = try? JSONEncoder().encode(transactions) else { return }
        defaults.set(data, forKey: key)
    }

    func load() -> [Transaction] {
        guard
            let data = defaults.data(forKey: key),
            let transactions = try? JSONDecoder().decode([Transaction].self, from: data)
        else {
            return []
        }
        return transactions
    }

    func clear() {
        defaults.removeObject(forKey: key)
    }
}
