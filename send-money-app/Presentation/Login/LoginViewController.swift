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
    }
    
    private func setupBindings() {
        viewModel.onStateChange = { [weak self] state in
            DispatchQueue.main.async {
                guard let self else { return }

                switch state {
                case .idle:
                    break
                case .loading:
                    self.loginButton.isEnabled = false
                    self.activityIndicator.startAnimating()
                case .success:
                    self.activityIndicator.stopAnimating()
                    self.loginButton.isEnabled = true
                    self.onLoginSuccess?()
                case .failure(let message):
                    self.activityIndicator.stopAnimating()
                    self.loginButton.isEnabled = true
                }
            }
        }
    }
    
    private func onLoginTapped() {
        viewModel.login(username: usernameTextField.text ?? "",
                        password: passwordTextField.text ?? ""
        )
    }
}

