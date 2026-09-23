//
//  DashboardViewModel.swift
//  send-money-app
//
//  Created by Allen Jeffrey Crisostomo on 9/23/26.
//

import Foundation

class DashboardViewModel {
    private let walletStore: WalletStore

    private(set) var isBalanceVisible = true {
        didSet { onBalanceChange?() }
    }

    var onBalanceChange: (() -> Void)?

    var balance: Decimal {
        walletStore.balance
    }

    init(walletStore: WalletStore) {
        self.walletStore = walletStore
    }

    func toggleBalanceVisibility() {
        isBalanceVisible.toggle()
    }

    func displayBalance() -> String {
        isBalanceVisible
            ? "₱\(NSDecimalNumber(decimal: balance).doubleValue.formatted(.number.precision(.fractionLength(2))))"
            : "****"
    }
}
