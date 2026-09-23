//
//  Transaction.swift
//  send-money-app
//
//  Created by Allen Jeffrey Crisostomo on 9/23/26.
//

import Foundation

struct TransactionAPIResponse: Codable {
    let id: Int
    let title: String
    let body: String
    let userId: Int
}

struct Transaction: Codable {
    let id: Int
    let amount: Decimal
    let date: Date
    let recipient: String
}
