//
//  AppContainer.swift
//  send-money-app
//
//  Created by Allen Jeffrey Crisostomo on 9/23/26.
//

import UIKit

class AppContainer {
    let authRepository: AuthRepositoryProtocol
    init() {
        let apiClient = APIClient()
        self.authRepository = AuthRepository(apiClient: apiClient)
    }
    
    func makeLoginViewController() -> UIViewController {
        let viewModel = LoginViewModel(
            authRepository: authRepository
        )
        let controller = LoginViewController(viewModel: viewModel)
        return controller
    }
}
