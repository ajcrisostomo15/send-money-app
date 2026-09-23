//
//  WalletStore.swift
//  send-money-app
//
//  Created by Allen Jeffrey Crisostomo on 9/23/26.
//

import Foundation

final class WalletStore {
    private(set) var balance: Decimal = 1_000

    func deduct(_ amount: Decimal) {
        balance -= amount
    }

    func reset() {
        balance = 1_000
    }
}
