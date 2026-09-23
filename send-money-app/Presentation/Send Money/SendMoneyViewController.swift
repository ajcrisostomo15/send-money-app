//
//  SendMoneyViewController.swift
//  send-money-app
//
//  Created by Allen Jeffrey Crisostomo on 9/23/26.
//

import UIKit
import SnapKit

class SendMoneyViewController: UIViewController {
    private lazy var noteLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter an amount greater than ₱0 and less than your wallet balance."
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        return label
    }()

    private lazy var amountField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Amount"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .decimalPad
        return textField
    }()

    private lazy var submitButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.title = "Submit"
        configuration.cornerStyle = .medium

        let button = UIButton(configuration: configuration)
        let action = UIAction(handler: { [weak self] _ in
            self?.submitTapped()
        })
        button.addAction(action, for: .touchUpInside)
        return button
    }()

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()

    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            noteLabel,
            amountField,
            submitButton,
            activityIndicator
        ])
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
    }
    
    private func setupInterface() {
        view.backgroundColor = .systemBackground
        view.addSubview(contentStackView)

        submitButton.snp.makeConstraints { make in
            make.height.equalTo(50)
        }

        contentStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(24)
            make.leading.trailing.equalTo(view.layoutMarginsGuide)
        }
    }

    private func submitTapped() {
        
    }
}
