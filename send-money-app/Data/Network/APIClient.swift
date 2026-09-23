//
//  APIClient.swift
//  send-money-app
//
//  Created by Allen Jeffrey Crisostomo on 9/22/26.
//

import Foundation

protocol APIClientProtocol {
    func request<T: Decodable>(_ endpoint: Endpoint, responseType: T.Type) async throws -> T
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

struct Endpoint {
    let path: String
    let method: HTTPMethod
    let body: Data?
}

enum AuthEndpoint {

    static func login(
        username: String,
        password: String
    ) throws -> Endpoint {

        let payload = [
            "username": username,
            "password": password
        ]

        let _ = try JSONSerialization.data(
            withJSONObject: payload
        )

        return Endpoint(
            path: "/users",
            method: .get,
            body: nil
        )
    }
}

enum TransactionEndpoint {
    static func send(
        amount: Decimal
    ) throws -> Endpoint {

        let payload: [String: Any] = [
            "title": "P\(amount)",
            "body": "Demo Recipient",
            "userId": 1
        ]

        let body = try JSONSerialization.data(
            withJSONObject: payload
        )

        return Endpoint(
            path: "/posts",
            method: .post,
            body: body
        )
    }
    
    static func history() throws -> Endpoint {
        return Endpoint(
            path: "/posts",
            method: .get,
            body: nil
        )
    }

}

enum APIError: LocalizedError {
    case invalidURL
    case invalidResponse
    case server(statusCode: Int)
    case decoding
    case encoding

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "The API URL is invalid."
        case .invalidResponse: return "The server returned an invalid response."
        case .server(let statusCode): return "The server returned status \(statusCode)."
        case .decoding: return "The server response could not be read."
        case .encoding: return "The request could not be encoded."
        }
    }
}

final class APIClient: APIClientProtocol {
    private let baseURL: URL
    private let session: URLSession

    init(
        baseURL: URL = URL(string: "https://jsonplaceholder.typicode.com")!,
        session: URLSession = .shared
    ) {
        self.baseURL = baseURL
        self.session = session
    }

    func request<T: Decodable>(
        _ endpoint: Endpoint,
        responseType: T.Type
    ) async throws -> T {
        let request = try makeRequest(endpoint)
        let (data, response) = try await session.data(for: request)
        try validate(response)

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw APIError.decoding
        }
    }

    private func makeRequest(_ endpoint: Endpoint) throws -> URLRequest {
        let url = baseURL.appendingPathComponent(endpoint.path.trimmingCharacters(in: CharacterSet(charactersIn: "/")))
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.httpBody = endpoint.body
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }

    private func validate(_ response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        guard (200..<300).contains(httpResponse.statusCode) else {
            throw APIError.server(statusCode: httpResponse.statusCode)
        }
    }
}
