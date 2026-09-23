//
//  BottomSheetViewController.swift
//  send-money-app
//
//  Created by Allen Jeffrey Crisostomo on 9/23/26.
//

import UIKit
import SnapKit

final class BottomSheetViewController: UIViewController {
    var onDismiss: (() -> Void)?

    private let titleText: String
    private let messageText: String

    private var titleLabel: UILabel {
        let label = UILabel()
        label.text = titleText
        label.font = .systemFont(ofSize: 24, weight: .bold)
        return label
    }

    private var messageLabel: UILabel {
        let label = UILabel()
        label.text = messageText
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        return label
    }

    private lazy var doneButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.title = "Done"
        configuration.cornerStyle = .medium

        let button = UIButton(configuration: configuration)
        let action = UIAction(handler: { [weak self] _ in
            self?.done()
        })
        button.addAction(action, for: .touchUpInside)
        return button
    }()

    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            titleLabel,
            messageLabel,
            doneButton
        ])
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()

    init(titleText: String, messageText: String) {
        self.titleText = titleText
        self.messageText = messageText
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
    }

    private func setupInterface() {
        view.backgroundColor = .systemBackground
        view.addSubview(contentStackView)

        doneButton.snp.makeConstraints { make in
            make.height.equalTo(50)
        }

        contentStackView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.layoutMarginsGuide)
            make.centerY.equalToSuperview()
        }
    }

    private func done() {
        onDismiss?()
    }
}
