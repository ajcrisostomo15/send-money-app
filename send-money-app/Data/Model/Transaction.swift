//
//  Transaction.swift
//  send-money-app
//
//  Created by Allen Jeffrey Crisostomo on 9/23/26.
//

import Foundation

struct TransactionAPIResponse: Codable {
    let id: String
}

struct Transaction: Codable {
    let id: String
    let amount: Decimal
    let date: Date
    let recipient: String
}
