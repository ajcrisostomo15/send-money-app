//
//  SendMoneyViewModelTests.swift
//  send-money-appTests
//
//  Created by Allen Jeffrey Crisostomo on 9/23/26.
//

import XCTest
@testable import send_money_app

final class SendMoneyViewModelTests: XCTestCase {

    func testSubmitEmitsFailureForInvalidAmount() {
        let repository = SendMoneyMockTransactionRepository()
        let viewModel = SendMoneyViewModel(
            walletStore: WalletStore(),
            transactionRepository: repository
        )
        var failureMessage: String?

        viewModel.onStateChange = { state in
            if case .failure(let message) = state {
                failureMessage = message
            }
        }

        viewModel.submit(amountText: "0")

        XCTAssertEqual(failureMessage, "Enter an amount greater than ₱0.")
        XCTAssertTrue(repository.sendMoneyCalls.isEmpty)
    }

    func testSubmitEmitsFailureWhenAmountIsNotLessThanBalance() {
        let repository = SendMoneyMockTransactionRepository()
        let viewModel = SendMoneyViewModel(
            walletStore: WalletStore(),
            transactionRepository: repository
        )
        var failureMessage: String?

        viewModel.onStateChange = { state in
            if case .failure(let message) = state {
                failureMessage = message
            }
        }

        viewModel.submit(amountText: "1000")

        XCTAssertEqual(failureMessage, "Amount must be less than your wallet balance.")
        XCTAssertTrue(repository.sendMoneyCalls.isEmpty)
    }

    func testSubmitEmitsLoadingThenSuccessAndDeductsBalance() {
        let walletStore = WalletStore()
        let transaction = Transaction(
            id: 42,
            amount: Decimal(125),
            date: Date(timeIntervalSince1970: 0),
            recipient: "Demo Recipient"
        )
        let repository = SendMoneyMockTransactionRepository(transaction: transaction)
        let viewModel = SendMoneyViewModel(
            walletStore: walletStore,
            transactionRepository: repository
        )
        let successExpectation = expectation(description: "Emits success state")
        var receivedStates: [SendMoneyViewModel.NetworkState] = []

        viewModel.onStateChange = { state in
            receivedStates.append(state)
            if case .success = state {
                successExpectation.fulfill()
            }
        }

        viewModel.submit(amountText: "125")

        wait(for: [successExpectation], timeout: 1.0)
        XCTAssertEqual(receivedStates.count, 2)
        XCTAssertTrue(receivedStates[0].isLoading)
        XCTAssertEqual(receivedStates[1].successTransaction?.id, transaction.id)
        XCTAssertEqual(repository.sendMoneyCalls, [Decimal(125)])
        XCTAssertEqual(walletStore.balance, Decimal(875))
    }

    func testSubmitEmitsFailureWhenRepositoryThrows() {
        let walletStore = WalletStore()
        let repository = SendMoneyMockTransactionRepository(error: TestError.network)
        let viewModel = SendMoneyViewModel(
            walletStore: walletStore,
            transactionRepository: repository
        )
        let failureExpectation = expectation(description: "Emits failure state")
        var receivedStates: [SendMoneyViewModel.NetworkState] = []

        viewModel.onStateChange = { state in
            receivedStates.append(state)
            if case .failure = state {
                failureExpectation.fulfill()
            }
        }

        viewModel.submit(amountText: "125")

        wait(for: [failureExpectation], timeout: 1.0)
        XCTAssertEqual(receivedStates.count, 2)
        XCTAssertTrue(receivedStates[0].isLoading)
        XCTAssertEqual(receivedStates[1].failureMessage, TestError.network.localizedDescription)
        XCTAssertEqual(repository.sendMoneyCalls, [Decimal(125)])
        XCTAssertEqual(walletStore.balance, Decimal(1_000))
    }
}

private final class SendMoneyMockTransactionRepository: TransactionRepositoryProtocol {
    private let transaction: Transaction
    private let error: Error?
    private(set) var sendMoneyCalls: [Decimal] = []

    init(
        transaction: Transaction = Transaction(
            id: 1,
            amount: Decimal(100),
            date: Date(timeIntervalSince1970: 0),
            recipient: "Demo Recipient"
        ),
        error: Error? = nil
    ) {
        self.transaction = transaction
        self.error = error
    }

    func sendMoney(amount: Decimal) async throws -> Transaction {
        sendMoneyCalls.append(amount)
        if let error {
            throw error
        }
        return transaction
    }

    func cachedTransactions() -> [Transaction] { [] }

    func fetchTransactions() async throws -> [Transaction] {
        []
    }
}

private enum TestError: LocalizedError {
    case network

    var errorDescription: String? {
        "Network unavailable"
    }
}

private extension SendMoneyViewModel.NetworkState {
    var isLoading: Bool {
        if case .loading = self {
            return true
        }
        return false
    }

    var successTransaction: Transaction? {
        if case .success(let transaction) = self {
            return transaction
        }
        return nil
    }

    var failureMessage: String? {
        if case .failure(let message) = self {
            return message
        }
        return nil
    }
}
