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
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
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
}

