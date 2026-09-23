//
//  TransactionHistoryViewModelTests.swift
//  send-money-appTests
//
//  Created by Allen Jeffrey Crisostomo on 9/23/26.
//

import XCTest
@testable import send_money_app

final class TransactionHistoryViewModelTests: XCTestCase {

    func testGetListOfHistoryEmitsLoadingThenLoadedAndStoresTransactions() {
        let transactions = [
            Transaction(
                id: 1,
                amount: Decimal(100),
                date: Date(timeIntervalSince1970: 0),
                recipient: "Alice"
            ),
            Transaction(
                id: 2,
                amount: Decimal(250),
                date: Date(timeIntervalSince1970: 100),
                recipient: "Bob"
            )
        ]
        let repository = HistoryMockTransactionRepository(transactions: transactions)
        let viewModel = TransactionHistoryViewModel(transactionRepository: repository)
        let loadedExpectation = expectation(description: "Emits loaded state")
        var receivedStates: [TransactionHistoryViewModel.NetworkState] = []

        viewModel.onStateChange = { state in
            receivedStates.append(state)
            if case .loaded = state {
                loadedExpectation.fulfill()
            }
        }

        viewModel.getListOfHistory()

        wait(for: [loadedExpectation], timeout: 1.0)
        XCTAssertEqual(receivedStates.count, 2)
        XCTAssertTrue(receivedStates[0].isLoading)
        XCTAssertEqual(receivedStates[1].loadedTransactions?.map(\.id), [1, 2])
        XCTAssertEqual(viewModel.transactions.map(\.recipient), ["Alice", "Bob"])
        XCTAssertEqual(repository.fetchTransactionsCallCount, 1)
    }

    func testGetListOfHistoryEmitsFailureWhenRepositoryThrows() {
        let repository = HistoryMockTransactionRepository(error: HistoryTestError.network)
        let viewModel = TransactionHistoryViewModel(transactionRepository: repository)
        let failureExpectation = expectation(description: "Emits failure state")
        var receivedStates: [TransactionHistoryViewModel.NetworkState] = []

        viewModel.onStateChange = { state in
            receivedStates.append(state)
            if case .failure = state {
                failureExpectation.fulfill()
            }
        }

        viewModel.getListOfHistory()

        wait(for: [failureExpectation], timeout: 1.0)
        XCTAssertEqual(receivedStates.count, 2)
        XCTAssertTrue(receivedStates[0].isLoading)
        XCTAssertEqual(receivedStates[1].failureMessage, HistoryTestError.network.localizedDescription)
        XCTAssertTrue(viewModel.transactions.isEmpty)
        XCTAssertEqual(repository.fetchTransactionsCallCount, 1)
    }
}

private final class HistoryMockTransactionRepository: TransactionRepositoryProtocol {
    private let transactions: [Transaction]
    private let error: Error?
    private(set) var fetchTransactionsCallCount = 0

    init(transactions: [Transaction] = [], error: Error? = nil) {
        self.transactions = transactions
        self.error = error
    }

    func sendMoney(amount: Decimal) async throws -> Transaction {
        Transaction(
            id: 1,
            amount: amount,
            date: Date(timeIntervalSince1970: 0),
            recipient: "Demo Recipient"
        )
    }

    func fetchTransactions() async throws -> [Transaction] {
        fetchTransactionsCallCount += 1
        if let error {
            throw error
        }
        return transactions
    }
}

private enum HistoryTestError: LocalizedError {
    case network

    var errorDescription: String? {
        "Network unavailable"
    }
}

private extension TransactionHistoryViewModel.NetworkState {
    var isLoading: Bool {
        if case .loading = self {
            return true
        }
        return false
    }

    var loadedTransactions: [Transaction]? {
        if case .loaded(let transactions) = self {
            return transactions
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
