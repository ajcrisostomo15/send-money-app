//
//  TransactionViewController.swift
//  send-money-app
//
//  Created by Allen Jeffrey Crisostomo on 9/23/26.
//

import UIKit
import SnapKit

class TransactionHistoryViewController: UIViewController {
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(TransactionCell.self, forCellReuseIdentifier: TransactionCell.reuseID)
        tableView.dataSource = self
        return tableView
    }()

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    private var transactions: [Transaction] = []
    private let viewModel: TransactionHistoryViewModel
    init(viewModel: TransactionHistoryViewModel) {
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
        loadHistoryList()
    }
    
    private func setupInterface() {
        title = "Transactions"
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        view.addSubview(activityIndicator)

        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func setupBindings() {
        viewModel.onStateChange = { [weak self] state in
            DispatchQueue.main.async {
                self?.handleState(state)
            }
        }
    }
    
    private func handleState(_ state: TransactionHistoryViewModel.NetworkState) {
        switch state {
        case .failure(let error):
            self.activityIndicator.stopAnimating()
            self.showAlert(message: error)
        case .loaded(let transactions):
            self.transactions = transactions
            self.activityIndicator.stopAnimating()
            self.tableView.reloadData()
        case .idle:
            break
        case .loading:
            self.activityIndicator.startAnimating()
        }
    }
    
    private func loadHistoryList() {
        viewModel.getListOfHistory()
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(
            title: "Transaction History",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension TransactionHistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        transactions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TransactionCell.reuseID,
            for: indexPath
        ) as? TransactionCell else {
            return UITableViewCell()
        }

        cell.configure(with: transactions[indexPath.row])
        return cell
    }
}

final class TransactionCell: UITableViewCell {
    static let reuseID = "TransactionCell"

    private lazy var recipientLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        return label
    }()

    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .secondaryLabel
        return label
    }()

    private lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textAlignment = .right
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()

    private var leftStackView: UIStackView {
        let stackView = UIStackView(arrangedSubviews: [
            recipientLabel,
            dateLabel
        ])
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }

    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            leftStackView,
            amountLabel
        ])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 12
        return stackView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupInterface()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with transaction: Transaction) {
        recipientLabel.text = transaction.recipient

        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        dateLabel.text = formatter.string(from: transaction.date)

        amountLabel.text = "₱\(NSDecimalNumber(decimal: transaction.amount).doubleValue.formatted(.number.precision(.fractionLength(2))))"
    }

    private func setupInterface() {
        contentView.addSubview(contentStackView)

        contentStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(12)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
}
