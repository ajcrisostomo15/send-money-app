//
//  LoginViewModelTests.swift
//  send-money-appTests
//
//  Created by Allen Jeffrey Crisostomo on 9/23/26.
//

import XCTest
@testable import send_money_app

final class LoginViewModelTests: XCTestCase {

    func testLoginEmitsLoadingThenSuccessWhenRepositoryReturnsTrue() {
        let repository = MockAuthRepository(result: true)
        let viewModel = LoginViewModel(authRepository: repository)
        let successExpectation = expectation(description: "Emits success state")
        var receivedStates: [LoginViewModel.NetworkState] = []

        viewModel.onStateChange = { state in
            receivedStates.append(state)
            if case .success = state {
                successExpectation.fulfill()
            }
        }

        viewModel.login(username: "allen", password: "password")

        wait(for: [successExpectation], timeout: 1.0)
        XCTAssertEqual(receivedStates.count, 2)
        XCTAssertTrue(receivedStates[0].isLoading)
        XCTAssertTrue(receivedStates[1].isSuccess)
        XCTAssertEqual(repository.loginCalls.count, 1)
        XCTAssertEqual(repository.loginCalls.first?.username, "allen")
        XCTAssertEqual(repository.loginCalls.first?.password, "password")
    }

    func testLoginEmitsFailureWhenRepositoryReturnsFalse() {
        let repository = MockAuthRepository(result: false)
        let viewModel = LoginViewModel(authRepository: repository)
        let failureExpectation = expectation(description: "Emits failure state")
        var failureMessage: String?

        viewModel.onStateChange = { state in
            if case .failure(let message) = state {
                failureMessage = message
                failureExpectation.fulfill()
            }
        }

        viewModel.login(username: "allen", password: "wrong")

        wait(for: [failureExpectation], timeout: 1.0)
        XCTAssertEqual(failureMessage, "Invalid username or password")
    }
}

private extension LoginViewModel.NetworkState {
    var isLoading: Bool {
        if case .loading = self {
            return true
        }
        return false
    }

    var isSuccess: Bool {
        if case .success = self {
            return true
        }
        return false
    }
}
