//
//  JwtUtilsTests.swift
//  NewtonAuthTests
//
//  Created by Mihail Kuznetsov on 21.05.2021.
//

import XCTest
@testable import NewtonAuth

class JwtUtilsTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_decodeToken_shouldBeValid() throws {
        let decodedToken = JWTUtils.decode(jwtToken: validToken)
        XCTAssertNotNil(decodedToken)
    }
    
    func test_decodeAuthFLowStateFromToken_shouldBeValid() throws {
        guard let authFlowData = JWTUtils.decodeAuthFlowState(jwtToken: validToken) else {
            XCTFail()
            return
        }
        XCTAssertNotNil(authFlowData)
        XCTAssertEqual(authFlowData.loginFlow, .normal)
        XCTAssertEqual(authFlowData.loginStep, .verifyPhoneCode)
        XCTAssertEqual(authFlowData.codeCanBeResubmittedTimestamp, 1624000787)
        XCTAssertNotNil(authFlowData.codeCanBeResubmittedTimestamp)
        let date = Date(timeIntervalSince1970: authFlowData.codeCanBeResubmittedTimestamp!)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        let yearString = dateFormatter.string(from: date)
        XCTAssertEqual(yearString, "2021")
    }
    
    func test_decodeAuthFLowStateFromTokenWithHeaderData_shouldBeValid() throws {
        let headerData = ["Date": "Mon, 17 Jan 2022 12:04:43 GMT"]
        guard let authFlowData = JWTUtils.decodeAuthFlowState(jwtToken: validToken, headerData: headerData) else {
            XCTFail()
            return
        }
        XCTAssertNotNil(authFlowData)
        XCTAssertNotNil(authFlowData.codeCanBeResubmittedTimestamp)
        XCTAssertNotEqual(authFlowData.codeCanBeResubmittedTimestamp, authFlowData.codeCanBeResubmittedTimestampFromData)
    }
    
    func test_jwtExpired_shouldBeTrue() {
        let jwtExpired = JWTUtils.jwtExpired(jwt: validToken)
        XCTAssertTrue(jwtExpired, "token not expired")
    }

}


private let validToken = """
    eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJ6Q2NVS1NRN3JZNkJNSVRWcDFzS09lejJUVE8tcElESGZLWW1EVmlnZEJNIn0.eyJleHAiOjE2MjQwMDEwMjcsImlhdCI6MTYyNDAwMDcyNywianRpIjoiNTM0OThkMTEtZmMxNi00YzBhLTgzNDctZGJlOWIxOGZiN2M2IiwiaXNzIjoiaHR0cHM6Ly9rZXljbG9hay5uZXd0b24tdGVjaG5vbG9neS5ydS9hdXRoL3JlYWxtcy9zZXJ2aWNlIiwiYXVkIjpbInVzZXJfcmVnaXN0ZXJlZCIsImFjY291bnQiXSwic3ViIjoiKzc5MjIyNzIzNDI3IiwidHlwIjoiQmVhcmVyIiwiYXpwIjoidGV6aXMiLCJzZXNzaW9uX3N0YXRlIjoiMzkxMmIyYjEtODhjYi00ZGE4LTlkODMtZGFiNzBiZjE4ZGVlIiwicGhvbmVfbnVtYmVyIjoiKzc5MjIyNzIzNDI3IiwiYWNyIjoiMSIsImFsbG93ZWQtb3JpZ2lucyI6WyIvKiJdLCJyZWFsbV9hY2Nlc3MiOnsicm9sZXMiOlsib2ZmbGluZV9hY2Nlc3MiLCJ1bWFfYXV0aG9yaXphdGlvbiJdfSwicmVzb3VyY2VfYWNjZXNzIjp7ImFjY291bnQiOnsicm9sZXMiOlsibWFuYWdlLWFjY291bnQiLCJtYW5hZ2UtYWNjb3VudC1saW5rcyIsInZpZXctcHJvZmlsZSJdfX0sInNjb3BlIjoiIiwiY29kZV9jYW5fYmVfcmVzdWJtaXR0ZWRfdGltZXN0YW1wIjoxNjI0MDAwNzg3LCJjb2RlX2V4cGlyZXNfdGltZXN0YW1wIjoxNjI0MDAxMDI3LCJsb2dpbl9zdGVwIjoiVkVSSUZZX1BIT05FX0NPREUiLCJsb2dpbl9mbG93IjoiTk9STUFMIiwibWFza2VkX2VtYWlsIjoibWkqKioqKioqKioqQCoqKioqLioqKiJ9.o7fzcHROum0r8Eina_5GXwkoTNsmGKJ81J8eTRORJ1cwaX8rgyNpeZYgwsJ8ykMmR7HvJ8FRBrwyjd7wORKvB0cw3wWiiLIc71ESB8JFwybIMn7gElQKlZuZYuwP97wKE4feCIS8RiIHTBf7_1jYu96xBi0jruZ3lYJDGHIK4hNA9eUG3fQD9sC1ITh5wwpXHnbRScucQRrcvCqakFd2o_CzqemS8dpKAr2Zhc8SmWkUboW4q0wy6cl_EjQKcZTsrDmaMBpJmKbyuH4NMC6Yp-ms0EU5P3LkvBfdP20LuWSAe7-O2OM2nzSzi_D4ROBo3DyZ-mv2BtSewCyCpAYrbg
"""
