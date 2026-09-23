//
//  ViewController.swift
//  send-money-app
//
//  Created by Allen Jeffrey Crisostomo on 9/22/26.
//

import UIKit
import SnapKit
class LoginViewController: UIViewController {

    private lazy var usernameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Username"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.black, for: .normal)
        
        let action = UIAction(handler: { [weak self] _ in
            self?.onLoginTapped()
        })
        
        button.addAction(action, for: .touchUpInside)
        return button
    }()

    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    var onLoginSuccess: (() -> Void)?
    
    private let viewModel: LoginViewModel
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
        setupBindings()
    }

    private func setupInterface() {
        view.backgroundColor = .white
        view.addSubview(usernameTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(activityIndicator)
        
        usernameTextField.snp.makeConstraints { (make) in
            let padding: CGFloat = 16
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(padding)
            make.right.equalToSuperview().inset(padding)
        }
        
        passwordTextField.snp.makeConstraints { make in
            let topPadding: CGFloat = 8
            let padding: CGFloat = 16
            make.top.equalTo(usernameTextField.snp.bottom).offset(topPadding)
            make.left.equalToSuperview().offset(padding)
            make.right.equalToSuperview().inset(padding)
        }
        
        loginButton.snp.makeConstraints { make in
            let topPadding: CGFloat = 8
            let padding: CGFloat = 16
            make.top.equalTo(passwordTextField.snp.bottom).offset(topPadding)
            make.left.equalToSuperview().offset(padding)
            make.right.equalToSuperview().inset(padding)
        }

        activityIndicator.hidesWhenStopped = true
        activityIndicator.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
        }
    }
    
    private func setupBindings() {
        viewModel.onStateChange = { [weak self] state in
            DispatchQueue.main.async {
                self?.handleState(state)
            }
        }
    }

    private func handleState(_ state: LoginViewModel.NetworkState) {
        switch state {
        case .idle:
            break
        case .loading:
            loginButton.isEnabled = false
            activityIndicator.startAnimating()
        case .success:
            activityIndicator.stopAnimating()
            loginButton.isEnabled = true
            onLoginSuccess?()
        case .failure(let message):
            activityIndicator.stopAnimating()
            loginButton.isEnabled = true
            showAlert(message: message)
        }
    }
    
    private func onLoginTapped() {
        viewModel.login(username: usernameTextField.text ?? "",
                        password: passwordTextField.text ?? ""
        )
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(
            title: "Login Failed",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

