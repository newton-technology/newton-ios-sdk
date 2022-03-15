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
    
    func test_jwtHasOtpChecks_shouldBeTrue() {
        guard let authFlowData = JWTUtils.decodeAuthFlowState(jwtToken: tokenWithOtpFields) else {
            XCTFail()
            return
        }
        XCTAssertEqual(authFlowData.otpChecksLeft, 6)
        XCTAssertEqual(authFlowData.otpSendsLeft, 999)
    }

}


private let validToken = """
    eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJ6Q2NVS1NRN3JZNkJNSVRWcDFzS09lejJUVE8tcElESGZLWW1EVmlnZEJNIn0.eyJleHAiOjE2MjQwMDEwMjcsImlhdCI6MTYyNDAwMDcyNywianRpIjoiNTM0OThkMTEtZmMxNi00YzBhLTgzNDctZGJlOWIxOGZiN2M2IiwiaXNzIjoiaHR0cHM6Ly9rZXljbG9hay5uZXd0b24tdGVjaG5vbG9neS5ydS9hdXRoL3JlYWxtcy9zZXJ2aWNlIiwiYXVkIjpbInVzZXJfcmVnaXN0ZXJlZCIsImFjY291bnQiXSwic3ViIjoiKzc5MjIyNzIzNDI3IiwidHlwIjoiQmVhcmVyIiwiYXpwIjoidGV6aXMiLCJzZXNzaW9uX3N0YXRlIjoiMzkxMmIyYjEtODhjYi00ZGE4LTlkODMtZGFiNzBiZjE4ZGVlIiwicGhvbmVfbnVtYmVyIjoiKzc5MjIyNzIzNDI3IiwiYWNyIjoiMSIsImFsbG93ZWQtb3JpZ2lucyI6WyIvKiJdLCJyZWFsbV9hY2Nlc3MiOnsicm9sZXMiOlsib2ZmbGluZV9hY2Nlc3MiLCJ1bWFfYXV0aG9yaXphdGlvbiJdfSwicmVzb3VyY2VfYWNjZXNzIjp7ImFjY291bnQiOnsicm9sZXMiOlsibWFuYWdlLWFjY291bnQiLCJtYW5hZ2UtYWNjb3VudC1saW5rcyIsInZpZXctcHJvZmlsZSJdfX0sInNjb3BlIjoiIiwiY29kZV9jYW5fYmVfcmVzdWJtaXR0ZWRfdGltZXN0YW1wIjoxNjI0MDAwNzg3LCJjb2RlX2V4cGlyZXNfdGltZXN0YW1wIjoxNjI0MDAxMDI3LCJsb2dpbl9zdGVwIjoiVkVSSUZZX1BIT05FX0NPREUiLCJsb2dpbl9mbG93IjoiTk9STUFMIiwibWFza2VkX2VtYWlsIjoibWkqKioqKioqKioqQCoqKioqLioqKiJ9.o7fzcHROum0r8Eina_5GXwkoTNsmGKJ81J8eTRORJ1cwaX8rgyNpeZYgwsJ8ykMmR7HvJ8FRBrwyjd7wORKvB0cw3wWiiLIc71ESB8JFwybIMn7gElQKlZuZYuwP97wKE4feCIS8RiIHTBf7_1jYu96xBi0jruZ3lYJDGHIK4hNA9eUG3fQD9sC1ITh5wwpXHnbRScucQRrcvCqakFd2o_CzqemS8dpKAr2Zhc8SmWkUboW4q0wy6cl_EjQKcZTsrDmaMBpJmKbyuH4NMC6Yp-ms0EU5P3LkvBfdP20LuWSAe7-O2OM2nzSzi_D4ROBo3DyZ-mv2BtSewCyCpAYrbg
"""

private let tokenWithOtpFields = """
    eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJ6Q2NVS1NRN3JZNkJNSVRWcDFzS09lejJUVE8tcElESGZLWW1EVmlnZEJNIn0.eyJleHAiOjE2NDcyNTk4ODYsImlhdCI6MTY0NzI1OTU4NiwianRpIjoiZWIxYzg0NDktOTU4My00MGNhLThlZjMtN2EwYjYxZDRmZjk2IiwiaXNzIjoiaHR0cHM6Ly9rZXljbG9hay5uZXd0b24tdGVjaG5vbG9neS5ydS9hdXRoL3JlYWxtcy9zZXJ2aWNlIiwiYXVkIjpbInVzZXJfcmVnaXN0ZXJlZCIsImFjY291bnQiXSwic3ViIjoiKzcwMDAwMDAwMDAwIiwidHlwIjoiQmVhcmVyIiwiYXpwIjoibW9iaWxlIiwic2Vzc2lvbl9zdGF0ZSI6ImU3OWE5MDgyLWRlMjYtNDM5OS1iNzVhLWI2ZGZlMTYwOTVmNSIsInBob25lX251bWJlciI6Iis3MDAwMDAwMDAwMCIsImFjciI6IjEiLCJyZWFsbV9hY2Nlc3MiOnsicm9sZXMiOlsib2ZmbGluZV9hY2Nlc3MiLCJ1bWFfYXV0aG9yaXphdGlvbiJdfSwicmVzb3VyY2VfYWNjZXNzIjp7ImFjY291bnQiOnsicm9sZXMiOlsibWFuYWdlLWFjY291bnQiLCJtYW5hZ2UtYWNjb3VudC1saW5rcyIsInZpZXctcHJvZmlsZSJdfX0sInNjb3BlIjoiZW1haWwgcHJvZmlsZSIsInNpZCI6ImU3OWE5MDgyLWRlMjYtNDM5OS1iNzVhLWI2ZGZlMTYwOTVmNSIsImJvX2NsaWVudF9pZCI6IjQwMDEyMDMyIiwiY29kZV9jYW5fYmVfcmVzdWJtaXR0ZWRfdGltZXN0YW1wIjoxNjQ3MjU5NjQ2LCJlbWFpbF92ZXJpZmllZCI6ZmFsc2UsImNvZGVfZXhwaXJlc190aW1lc3RhbXAiOjE2NDcyNTk4ODYsInVzZXJfaWQiOjExMzgsIm90cF9jaGVja3NfbGVmdCI6NiwibG9naW5fc3RlcCI6IlZFUklGWV9QSE9ORV9DT0RFIiwib3RwX3NlbmRzX2xlZnQiOjk5OSwicHJlZmVycmVkX3VzZXJuYW1lIjoiKzcwMDAwMDAwMDAwIiwibG9naW5fZmxvdyI6Ik5PUk1BTCIsInRva2VuX3R5cGUiOiJTRVJWSUNFIiwibWFza2VkX2VtYWlsIjoiZGQqKioqKkAqKi4qKiJ9.CUdr5KtFRPAQDwO-7Kpcl1a3MMyubqa_QscOTochGqXPAxpEULzicNR8mpd30-GVKz2oSKwpjawYEISTQsnngrUXuWty2TqfA40GoGQ7BEYzMJriVHyDMGozfRnSME7z-3w_dKZHR7Hy4keZV_9ArkKeWhCJzpLj5fvgu7W50Q2UFjaq-JxsmlweEdouGcgEJMOGc-dZ8RGSZTRT3QfIduN502ltQuum_b_i2I7PyduFanen8AcAzMYR6GoTDPKEeJgwXIMkArIhkZxgZb4C1YisHFos5UvqYg5bqRBdTPtzbvZ_aDVRDiYKBpvjHaQpylTZwOMIB7QJEArPtDtx-g
"""
