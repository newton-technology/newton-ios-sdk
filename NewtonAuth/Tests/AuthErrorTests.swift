//
//  AuthErrorTests.swift
//  
//
//  Created by Mihail Kuznetsov on 28.04.2021.
//

import XCTest
@testable import NewtonAuth

final class AuthErrorTests: XCTestCase {
    
    func testDecoding() throws {
        let authError = try JSONDecoder().decode(AuthError.self, from: AuthGrantTypeError)
        XCTAssertEqual(authError.error, .unsupportedGrantType)
    }
    
    func testDecoding_whenReceivedUnknownErrorCode() throws {
        let authError = try JSONDecoder().decode(AuthError.self, from: AuthErrorUnknownCode)
        XCTAssertEqual(authError.error, .unknownError)
    }
    
    func testDecoding_whenMissingAttributes_itThrows() {
        XCTAssertThrowsError(try JSONDecoder().decode(AuthError.self, from: AuthErrorMissingErrorKey))
    }
    
    static var allTests = [
        ("testDecoding", testDecoding),
        ("testDecoding_whenMissingAttributes_itThrows", testDecoding_whenMissingAttributes_itThrows)
    ]

}


private let AuthGrantTypeError = Data("""
    {
        "error": "unsupported_grant_type"
    }
""".utf8)

private let AuthErrorUnknownCode = Data("""
    {
        "error": "completely_unknown_error_code"
    }
""".utf8)

private let AuthErrorMissingErrorKey = Data("""
    {
        "error_description": "Unsupported grant_type"
    }
""".utf8)
