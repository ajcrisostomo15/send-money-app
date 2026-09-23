# Send Money App

A UIKit-based iOS sample app for logging in, viewing a wallet balance, sending money, and reviewing transaction history. The app uses an MVVM-style structure, repository protocols for data access, and SnapKit for programmatic Auto Layout.

## Features

- Login with username and password validation
- Dashboard with wallet balance display and balance visibility toggle
- Send money flow with amount validation
- Transaction history list
- Local transaction caching with `UserDefaults`
- Unit tests for login, send money, and transaction history view models

## Tech Stack

- Swift
- UIKit
- SnapKit
- XCTest
- URLSession async/await networking
- JSONPlaceholder demo API

## Project Structure

```text
send-money-app/
├── Core/
│   ├── Persistence/
│   │   └── TransactionCache.swift
│   └── Session/
│       ├── SessionStore.swift
│       └── WalletStore.swift
├── Data/
│   ├── Model/
│   │   ├── Transaction.swift
│   │   └── User.swift
│   ├── Network/
│   │   └── APIClient.swift
│   └── Repository/
│       ├── AuthRepository.swift
│       └── TransactionRepository.swift
├── Presentation/
│   ├── Dashboard/
│   ├── Login/
│   ├── Send Money/
│   └── Transaction/
└── AppContainer.swift
```

## Architecture

The app follows a simple MVVM approach:

- View controllers own UIKit views and bind to view model state callbacks.
- View models handle validation, loading states, and user actions.
- Repositories handle API requests and data mapping.
- Stores hold shared app state such as wallet balance.
- `AppContainer` wires dependencies and creates view controllers.

## Getting Started

1. Open the project in Xcode.
2. Select the `send-money-app` scheme.
3. Choose an iOS simulator.
4. Build and run the app.

## Login

The app validates against users loaded from the demo API. Use a username returned by JSONPlaceholder and the password below:

```text
password
```

Example username:

```text
Bret
```

## Testing

Run tests from Xcode with `Command-U`, or select the `send-money-app` test plan and run the unit test target.

Current unit test coverage includes:

- `LoginViewModelTests`
- `SendMoneyViewModelTests`
- `TransactionHistoryViewModelTests`

## Dependencies

The project uses SnapKit for Auto Layout constraints. The dependency is included in the workspace/project structure.
