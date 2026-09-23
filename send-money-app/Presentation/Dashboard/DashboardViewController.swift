//
//  DashboardViewController.swift
//  send-money-app
//
//  Created by Allen Jeffrey Crisostomo on 9/23/26.
//

import UIKit
import SnapKit

class DashboardViewController: UIViewController {
    private var balanceTitleLabel: UILabel {
        let label = UILabel()
        label.text = "Wallet Balance"
        label.font = .systemFont(ofSize: 17, weight: .medium)
        return label
    }

    private lazy var balanceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 34, weight: .bold)
        return label
    }()

    private lazy var visibilityButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "eye"), for: .normal)
        let action = UIAction(handler: { [weak self] _ in
            self?.toggleBalance()
        })
        button.addAction(action, for: .touchUpInside)
        return button
    }()

    private lazy var balanceRowStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            balanceLabel,
            visibilityButton
        ])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 12
        return stackView
    }()

    private lazy var balanceCardStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            balanceTitleLabel,
            balanceRowStackView
        ])
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()

    private lazy var balanceCardView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemGroupedBackground
        view.layer.cornerRadius = 16
        view.addSubview(balanceCardStackView)
        return view
    }()

    private lazy var sendButton: UIButton = {
        let button = makeButton(title: "Send Money")
        let action = UIAction(handler: { [weak self] _ in
            self?.didTappedSendMoney()
        })
        button.addAction(action, for: .touchUpInside)
        return button
    }()

    private lazy var historyButton: UIButton = {
        let button = makeButton(title: "Transaction History")
        let action = UIAction(handler: { [weak self] _ in
            self?.didTappedTransactions()
        })
        button.addAction(action, for: .touchUpInside)
        return button
    }()

    private lazy var logoutButton: UIButton = {
        let button = makeButton(title: "Logout")
        button.configuration?.baseBackgroundColor = .systemGray
        return button
    }()

    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            balanceCardView,
            sendButton,
            historyButton,
            logoutButton
        ])
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    private let viewModel: DashboardViewModel
    private var isBalanceVisible = true
    public var onSendMoney: (() -> Void)?
    public var onTransactions: (() -> Void)?
    init(viewModel: DashboardViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
        updateBalance()
    }
    
    private func setupInterface() {
        view.backgroundColor = .systemGroupedBackground
        view.addSubview(contentStackView)

        balanceCardStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }

        contentStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(24)
            make.leading.trailing.equalTo(view.layoutMarginsGuide)
        }
    }

    private func makeButton(title: String) -> UIButton {
        var configuration = UIButton.Configuration.filled()
        configuration.title = title
        configuration.cornerStyle = .medium

        let button = UIButton(configuration: configuration)
        button.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        return button
    }

    private func toggleBalance() {
        let walletBalance = viewModel.displayBalance()
        isBalanceVisible.toggle()
        balanceLabel.text = isBalanceVisible ? walletBalance : "********"
        visibilityButton.setImage(
            UIImage(systemName: isBalanceVisible ? "eye" : "eye.slash"),
            for: .normal
        )
    }
    
    private func updateBalance() {
        balanceLabel.text = viewModel.displayBalance()
        visibilityButton.setImage(
            UIImage(systemName: viewModel.isBalanceVisible ? "eye.slash" : "eye"),
            for: .normal
        )
    }
    
    private func didTappedSendMoney() {
        onSendMoney?()
    }
    
    private func didTappedTransactions() {
        onTransactions?()
    }
}
