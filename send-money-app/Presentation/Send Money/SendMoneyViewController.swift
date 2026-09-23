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

    private let viewModel: SendMoneyViewModel
    init(viewModel: SendMoneyViewModel) {
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
    
    private func setupBindings() {
        viewModel.onStateChange = { [weak self] state in
            DispatchQueue.main.async {
                self?.handleState(state)
            }
        }
    }
    
    private func handleState(_ state: SendMoneyViewModel.NetworkState) {
        switch state {
        case .idle:
            break
        case .loading:
            self.submitButton.isEnabled = false
            self.activityIndicator.startAnimating()
        case .success(let transaction):
            self.submitButton.isEnabled = true
            self.activityIndicator.stopAnimating()
            self.showBottomSheet(
                title: "Money Sent",
                message: "₱\(NSDecimalNumber(decimal: transaction.amount).doubleValue.formatted(.number.precision(.fractionLength(2)))) was sent successfully."
            )
        case .failure(let message):
            self.submitButton.isEnabled = true
            self.activityIndicator.stopAnimating()
            self.showBottomSheet(title: "Unable to Send", message: message)
        }
    }

    private func showBottomSheet(title: String, message: String) {
        let sheet = BottomSheetViewController(titleText: title, messageText: message)
        sheet.onDismiss = { [weak self] in
            self?.dismiss(animated: true)
        }

        let navigation = UINavigationController(rootViewController: sheet)
        if let presentation = navigation.sheetPresentationController {
            presentation.detents = [.medium()]
            presentation.prefersGrabberVisible = true
        }
        present(navigation, animated: true)
    }
    
    private func submitTapped() {
        viewModel.submit(amountText: amountField.text ?? "")
    }
    
}
