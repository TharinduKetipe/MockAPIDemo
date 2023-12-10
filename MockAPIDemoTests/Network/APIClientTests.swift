//
//  APIClientTests.swift
//  MockAPIDemoTests
//
//  Created by Tharindu Ketipearachchi on 2023-12-10.
//
import XCTest
@testable import MockAPIDemo
/**
 This incuded the unit tests for APIClient
 */
final class APIClientTests: XCTestCase {
    private var sut: APIClient!
    
    override func setUp() {
        super.setUp()
        
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession(configuration: configuration)
        
        sut = APIClient(session: urlSession)
    }
    
    override func tearDown() {
        sut = nil
        
        super.tearDown()
    }
    
    // MARK: PostResource Success
    
    func testPostResourceSuccess() {
        // Given
        let url = MockAPIEndpoint.register.url!
        let data = User(username: "jane", age: "25", phone: "011234578", companyID: "CID09888")
        
        let expectedResponseData = """
            {
                "message": "User registered successfully",
            }
            """.data(using: .utf8)!
        
        MockURLProtocol.requestHandler = { request in
            // Check the Http Request
            XCTAssertEqual(request.httpMethod!, "POST")
            XCTAssertEqual(request.value(forHTTPHeaderField: HTTPHeaderField.contentType.rawValue), ContentType.json.rawValue)
            return (HTTPURLResponse(url: url, statusCode: 201, httpVersion: nil, headerFields: nil)!, expectedResponseData)
        }
        
        let expectation = expectation(description: "Post Resource Success")
        
        // When
        Task {
            do {
                let result: UserRegisterRes = try await sut.postResource(to: url, body: data, decodeTo: UserRegisterRes.self)
                
                // Check the Http Response
                XCTAssertEqual(result.message, "User registered successfully")
                expectation.fulfill()
            } catch {
                XCTFail("An error occurred during the asynchronous call: \(error)")
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 0.1, handler: nil)
    }
    
    // MARK: PostResource Error

    func testPostResourceServerError() {
        // Given
        let url = MockAPIEndpoint.register.url!
        let data = User(username: "jane", age: "25", phone: "011234578", companyID: "CID09888")

        let jsonData = """
            {
                "error": "Invalid data",
                "error_description": "User already exist"
            }
            """.data(using: .utf8)!

        MockURLProtocol.requestHandler = { _ in
            return (HTTPURLResponse(url: url, statusCode: 400, httpVersion: nil, headerFields: nil)!, jsonData)
        }

        let expectation = expectation(description: "Post Resource Server Error")

        // When
        Task {
            do {
                _ = try await sut.postResource(to: url, body: data, decodeTo: UserRegisterRes.self)

                // Then
                XCTFail("The test should throw a server error for an error response.")
                expectation.fulfill()
            } catch let error as APIError {
                switch error {
                case .serverError(let description):
                    XCTAssertEqual(description, "User already exist")
                default:
                    XCTFail("The test should throw a server error for an error response.")
                }
                expectation.fulfill()
            } catch {
                XCTFail("The test should throw a server error for an error response.")
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 0.1, handler: nil)
    }
}
