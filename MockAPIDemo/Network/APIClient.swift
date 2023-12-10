//
//  APIClient.swift
//  MockAPIDemo
//
//  Created by Tharindu Ketipearachchi on 2023-12-10.
//
import Foundation
/**
 Enum for APIError types
 */
enum APIError: Error {
    case serverError(String)
    case unknownError(Int)
    case invalidURL
    case invalidResponse
}
/**
 Enum for HTTP Methods
 */
enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}
/**
 Enum for Content Types
 */
enum ContentType: String {
    case json = "application/json"
}
/**
 Enum for Authe Types
 */
enum AuthType: String {
    case bearer = "Bearer"
}
/**
 Enum for HTTP Heeader Fields
 */
enum HTTPHeaderField: String {
    case contentType = "Content-Type"
    case authorization = "Authorization"
}
/**
 APIClient Protocol
 */
protocol APIClientProtocol {
    func postResource<T: Decodable, E: Encodable>( to url: URL, body: E?, decodeTo type: T.Type) async throws -> T
}
/**
 APIClient Implementation
 */
struct APIClient: APIClientProtocol {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func postResource<T: Decodable, E: Encodable>( to url: URL, body: E?, decodeTo type: T.Type) async throws -> T {
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        
        setHeaders(request: &request, token: "accessToken")
        
        do {
            let encoder = JSONEncoder()
            let requestData = try encoder.encode(body)
            request.httpBody = requestData
            
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }
            switch httpResponse.statusCode {
            case 200...299:
                do {
                    let decoder = JSONDecoder()
                    let decoded = try decoder.decode(T.self, from: data)
                    return decoded
                } catch {
                    throw APIError.invalidResponse
                }
            case 400...499:
                if let error = try? JSONDecoder().decode(ServerError.self, from: data) {
                    throw APIError.serverError(error.errorDescription)
                } else {
                    throw APIError.invalidResponse
                }
            case 500...599:
                throw APIError.unknownError(httpResponse.statusCode)
            default:
                throw APIError.invalidResponse
            }
        }
    }
}
/**
 Request Handling Extensions
 */
extension APIClient {
    func setHeaders(request: inout URLRequest, token: String) {
        request.addValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        request.addValue("\(AuthType.bearer.rawValue) \(token)", forHTTPHeaderField: HTTPHeaderField.authorization.rawValue)
    }
}
