//
//  AppContainer.swift
//  send-money-app
//
//  Created by Allen Jeffrey Crisostomo on 9/23/26.
//

import UIKit

class AppContainer {
    let authRepository: AuthRepositoryProtocol
    let walletStore: WalletStore
    let transactionRepository: TransactionRepositoryProtocol
    init() {
        let apiClient = APIClient()
        self.authRepository = AuthRepository(apiClient: apiClient)
        self.walletStore = WalletStore()
        self.transactionRepository = TransactionRepository(apiClient: apiClient)
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
        let viewModel = DashboardViewModel(walletStore: walletStore)
        let controller = DashboardViewController(viewModel: viewModel)
        
        controller.onSendMoney = { [weak self, weak controller] in
            guard let self, let controller else { return }
            controller.navigationController?.pushViewController(
                self.makeSendMoneyViewController(),
                animated: true
            )
        }
        
        return controller
    }
    
    func makeSendMoneyViewController() -> UIViewController {
        let viewModel = SendMoneyViewModel(walletStore: walletStore,
                                           transactionRepository: transactionRepository
        )
        let controller = SendMoneyViewController(viewModel: viewModel)
        return controller
    }
}
