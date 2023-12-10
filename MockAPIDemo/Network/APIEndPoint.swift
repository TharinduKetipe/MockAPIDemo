//
//  APIEndPoint.swift
//  MockAPIDemo
//
//  Created by Tharindu Ketipearachchi on 2023-12-10.
//
import Foundation
/**
 API EndPoints for MockAPIDemo APIs
 */
enum APIEndpoint {
    static let baseURL: String = "https://mockapidemo.com"
    
    case register
    
    var url: URL? {
        switch self {
        case .register:
            return URL(string: "\(APIEndpoint.baseURL)/user/register")
        }
    }
}
