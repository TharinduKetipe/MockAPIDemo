//
//  UserAPI.swift
//  MockAPIDemo
//
//  Created by Tharindu Ketipearachchi on 2023-12-10.
//
/**
 User API Protocol
 */
protocol UserAPIProtocol {
    func registerUser(request: User) async throws -> UserRegisterRes
}
/**
 User API Implementation
 */
struct UserAPI: UserAPIProtocol {
    
    private let apiClient: APIClientProtocol
    
    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }
    
    func registerUser(request: User) async throws -> UserRegisterRes {
        guard let url = APIEndpoint.register.url else {
            throw APIError.invalidURL
        }
        
        return try await apiClient.postResource(to: url, body: request, decodeTo: UserRegisterRes.self)
    }
}
