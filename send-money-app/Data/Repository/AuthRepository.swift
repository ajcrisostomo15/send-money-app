//
//  AuthRepository.swift
//  send-money-app
//
//  Created by Allen Jeffrey Crisostomo on 9/22/26.
//

import Foundation

protocol AuthRepositoryProtocol {
    func login(username: String, password: String) async throws -> Bool
}

class AuthRepository: AuthRepositoryProtocol {
    private let apiClient: APIClientProtocol
    
    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }
    
    func login(username: String, password: String) async throws -> Bool {
        guard !username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !password.isEmpty else {
            return false
        }

        let endpoint = try AuthEndpoint.login(username: username, password: password)
        let userList: [User] = try await apiClient.request(endpoint, responseType: [User].self)
        let validUser = userList.contains { user in
            user.username == username
        }
        
        return validUser && password == "password"
    }
}
