//
//  MockAuthRepository.swift
//  send-money-appTests
//
//  Created by Allen Jeffrey Crisostomo on 9/23/26.
//

@testable import send_money_app

final class MockAuthRepository: AuthRepositoryProtocol {
    private let result: Bool
    private let error: Error?
    private(set) var loginCalls: [(username: String, password: String)] = []

    init(result: Bool, error: Error? = nil) {
        self.result = result
        self.error = error
    }

    func login(username: String, password: String) async throws -> Bool {
        loginCalls.append((username, password))
        if let error {
            throw error
        }
        return result
    }
}
