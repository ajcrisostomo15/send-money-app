//
//  ViewController.swift
//  send-money-app
//
//  Created by Allen Jeffrey Crisostomo on 9/22/26.
//

import UIKit
import SnapKit
class LoginViewController: UIViewController {

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Send Money"
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.textAlignment = .center
        return label
    }()

    private lazy var usernameTextField: UITextField = {
        let textField = makeTextField(placeholder: "Username")
        return textField
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = makeTextField(placeholder: "Password")
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private lazy var loginButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.title = "Login"
        configuration.cornerStyle = .medium

        let button = UIButton(configuration: configuration)
        let action = UIAction(handler: { [weak self] _ in
            self?.onLoginTapped()
        })

        button.addAction(action, for: .touchUpInside)
        return button
    }()

    private let activityIndicator = UIActivityIndicatorView(style: .medium)

    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            titleLabel,
            usernameTextField,
            passwordTextField,
            loginButton,
            activityIndicator
        ])
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
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
        view.backgroundColor = .systemGroupedBackground
        view.addSubview(contentStackView)

        [usernameTextField, passwordTextField].forEach { textField in
            textField.snp.makeConstraints { make in
                make.height.equalTo(48)
            }
        }

        loginButton.snp.makeConstraints { make in
            make.height.equalTo(50)
        }

        activityIndicator.hidesWhenStopped = true
        contentStackView.setCustomSpacing(32, after: titleLabel)
        contentStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalTo(view.layoutMarginsGuide)
        }
    }
    
    private func setupBindings() {
        viewModel.onStateChange = { [weak self] state in
            DispatchQueue.main.async {
                self?.handleState(state)
            }
        }
    }

    private func makeTextField(placeholder: String) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.borderStyle = .none
        textField.backgroundColor = .systemBackground
        textField.layer.borderColor = UIColor.systemBlue.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 8
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        textField.leftViewMode = .always
        return textField
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

