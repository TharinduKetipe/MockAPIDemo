//
//  MockAPIEndPoint.swift
//  MockAPIDemoTests
//
//  Created by Tharindu Ketipearachchi on 2023-12-10.
//
import Foundation
/**
 Mock API EndPoints for MockAPIDemo Tests
 */
enum MockAPIEndpoint {
    static let baseURL: String = "https://mock.mockapidemo.com"
    
    case register
    
    var url: URL? {
        switch self {
        case .register:
            return URL(string: "\(MockAPIEndpoint.baseURL)/user/register")
        }
    }
}
