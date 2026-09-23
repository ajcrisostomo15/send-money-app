//
//  LoginViewModel.swift
//  send-money-app
//
//  Created by Allen Jeffrey Crisostomo on 9/22/26.
//

import Foundation

class LoginViewModel {
    enum NetworkState {
        case idle
        case loading
        case success
        case failure(String)
    }
    
    private let authRepository: AuthRepositoryProtocol
    
    public var onStateChange: ((NetworkState) -> Void)?
    init(authRepository: AuthRepositoryProtocol) {
        self.authRepository = authRepository
    }
    
    func login(username: String, password: String) {
        onStateChange?(NetworkState.loading)
        
        Task {
            do {
                let success = try await authRepository.login(username: username,
                                                             password: password
                )
                
                if success {
                    onStateChange?(NetworkState.success)
                } else {
                    onStateChange?(.failure("Invalid username or password"))
                }
            } catch {
                onStateChange?(.failure(error.localizedDescription))
            }
        }
    }
}
