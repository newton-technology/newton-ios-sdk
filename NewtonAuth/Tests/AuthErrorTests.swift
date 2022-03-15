//
//  AuthErrorTests.swift
//  
//
//  Created by Mihail Kuznetsov on 28.04.2021.
//

import XCTest
@testable import NewtonAuth

final class AuthErrorTests: XCTestCase {
    
    func test_decode_shouldBeValid() throws {
        let authError = try JSONDecoder().decode(AuthError.self, from: AuthGrantTypeError)
        XCTAssertEqual(authError.error, .unsupportedGrantType)
    }
    
    func test_decode_whenReceivedUnknownErrorCode_itThrows() throws {
        let authError = try JSONDecoder().decode(AuthError.self, from: AuthErrorUnknownCode)
        XCTAssertEqual(authError.error, .unknownError)
    }
    
    func test_decode_whenMissingAttributes_itThrows() {
        XCTAssertThrowsError(try JSONDecoder().decode(AuthError.self, from: AuthErrorMissingErrorKey))
    }
    
    func test_decode_hasOtpFields_itThrows() throws {
        let authError = try JSONDecoder().decode(AuthError.self, from: AuthErrorWithOtpChecks)
        XCTAssertEqual(authError.otpChecksLeft, 5)
        XCTAssertEqual(authError.otpSendsLeft, 10)
        
    }

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

private let AuthErrorWithOtpChecks = Data("""
    {
        "error": "invalid_grant",
        "otp_checks_left": 5,
        "otp_sends_left": 10
    }
""".utf8)
