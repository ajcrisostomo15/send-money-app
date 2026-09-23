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
        controller.onLoginSuccess = { [weak self, weak controller] in
            guard let self, let controller else { return }
            let dashboard = self.makeDashboardViewController()
            controller.navigationController?.setViewControllers([dashboard], animated: true)
        }
        return controller
    }
    
    func makeDashboardViewController() -> UIViewController {
        let viewModel = DashboardViewModel()
        let controller = DashboardViewController(viewModel: viewModel)
        return controller
    }
}
