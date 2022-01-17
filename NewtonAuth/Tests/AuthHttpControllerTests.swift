//
//  AuthHttpControllerTests.swift
//  NewtonAuthTests
//
//  Created by Mihail Kuznetsov on 28.04.2021.
//

import Foundation
import XCTest
@testable import NewtonAuth

class AuthHttpControllerTests: XCTestCase {
    
    var clientId: String!
    var serviceRealm: String!
    var phoneNumber: String!
    var url: URL!

    override func setUpWithError() throws {
        //TODO: move test settings to config file
        url = URL(string: "https://keycloak.newton-technology.ru")
        clientId = "mobile"
        serviceRealm = "service"
        phoneNumber = "+70000000000"
    }

    override func tearDownWithError() throws {
        //
    }
    
    func test_request_shouldBeSuccessfulWithValidAuthResult() {
        let httpController = AuthHttpController.instance
        let successExcpectation = expectation(description: "request success")
        guard
            let realm = serviceRealm,
            let client = clientId,
            let phone = phoneNumber,
            let authUrl = URL(string: "/auth/realms/\(realm)/protocol/openid-connect/token", relativeTo: url)
        else {
            return
        }
        let parameters = [
            "grant_type": "password",
            "client_id": client,
            "phone_number": phone
        ]
        httpController.request(
            url: authUrl,
            method: .post,
            resultModel: AuthResult.self,
            parameters: parameters,
            onSuccess: { code, authResult in
                XCTAssertNotNil(authResult)
                XCTAssertEqual(authResult?.tokenType, "Bearer")
                successExcpectation.fulfill()
            },
            onError: { error, code, authError in
                XCTFail("fail with auth error \(String(describing: authError))")
                successExcpectation.fulfill()
            }
        )
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func test_request_shouldFailWithUnsupportedGrantType() {
        let httpController = AuthHttpController.instance
        let successExcpectation = expectation(description: "request fail")

        guard
            let realm = serviceRealm,
            let client = clientId,
            let phone = phoneNumber,
            let authUrl = URL(string: "/auth/realms/\(realm)/protocol/openid-connect/token", relativeTo: url)
        else {
            return
        }
        let parameters = [
            "grant_type": "unknokn grant type",
            "client_id": client,
            "phone_number": phone
        ]
        httpController.request(
            url: authUrl,
            method: .post,
            resultModel: AuthResult.self,
            parameters: parameters,
            onSuccess: { code, authResult in
                XCTFail("should not be successful with")
                successExcpectation.fulfill()
            },
            onError: { error, code, authError in
                XCTAssertNotNil(authError)
                XCTAssertEqual(authError?.error, .unsupportedGrantType)
                successExcpectation.fulfill()
            }
        )
        waitForExpectations(timeout: 20.0, handler: nil)
    }

    func test_request_shouldFailWithInvalidClient() {
        let httpController = AuthHttpController.instance
        let successExcpectation = expectation(description: "request fail")

        guard
            let realm = serviceRealm,
            let phone = phoneNumber,
            let authUrl = URL(string: "/auth/realms/\(realm)/protocol/openid-connect/token", relativeTo: url)
        else {
            return
        }
        let parameters = [
            "grant_type": "password",
            "client_id": "unknown_client",
            "phone_number": phone
        ]
        httpController.request(
            url: authUrl,
            method: .post,
            resultModel: AuthResult.self,
            parameters: parameters,
            onSuccess: { code, authResult in
                XCTFail("should not be successful")
                successExcpectation.fulfill()
            },
            onError: { error, code, authError in
                XCTAssertNotNil(authError)
                XCTAssertEqual(authError?.error, .invalidClient)
                successExcpectation.fulfill()
            }
        )
        waitForExpectations(timeout: 20.0, handler: nil)
    }
    
    func test_request_shouldFailWithInvalidRequest() {
        let httpController = AuthHttpController.instance
        let successExcpectation = expectation(description: "request fail")

        guard
            let realm = serviceRealm,
            let authUrl = URL(string: "/auth/realms/\(realm)/protocol/openid-connect/token", relativeTo: url)
        else {
            return
        }
        httpController.request(
            url: authUrl,
            method: .post,
            resultModel: AuthResult.self,
            onSuccess: { code, authResult in
                XCTFail("should not be successful")
                successExcpectation.fulfill()
            },
            onError: { error, code, authError in
                XCTAssertNotNil(authError)
                XCTAssertEqual(authError?.error, .invalidRequest)
                successExcpectation.fulfill()
            }
        )
        waitForExpectations(timeout: 20.0, handler: nil)
    }
}
