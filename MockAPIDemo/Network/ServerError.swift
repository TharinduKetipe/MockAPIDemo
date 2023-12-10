//
//  ServerError.swift
//  MockAPIDemo
//
//  Created by Tharindu Ketipearachchi on 2023-12-10.
//
import Foundation
/**
 Model for Server Error
 */
struct ServerError: Codable {
    let error, errorDescription: String

    enum CodingKeys: String, CodingKey {
        case error
        case errorDescription = "error_description"
    }
}
