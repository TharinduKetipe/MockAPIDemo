//
//  User.swift
//  MockAPIDemo
//
//  Created by Tharindu Ketipearachchi on 2023-12-10.
//
import Foundation
/**
 Model for User Register Request
 */
struct User: Codable {
    let username: String
    let age: String
    let phone: String
    let companyID: String
}
