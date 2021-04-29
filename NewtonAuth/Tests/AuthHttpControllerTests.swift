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
        clientId = "tezis"
        serviceRealm = "service"
        phoneNumber = "+79..."
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
            parameters: parameters,
            onSuccess: { (code, authResult: AuthResult?) in
                XCTAssertEqual(authResult?.tokenType, "Bearer")
                successExcpectation.fulfill()
            }
        )
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func test_request_shouldFailWithUnsupportedGrantType() {
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
            "grant_type": "unknown_grant_type",
            "client_id": client,
            "phone_number": phone
        ]
        httpController.request(
            url: authUrl,
            method: .post,
            parameters: parameters,
            onSuccess: { (code, authResult: AuthResult?) in
                //
            },
            onError: { error, code, authError in
                XCTAssertEqual(authError?.error, .unsupportedGrantType)
                successExcpectation.fulfill()
            }
        )
        waitForExpectations(timeout: 20.0, handler: nil)
    }

    func test_request_shouldFailWithInvalidClient() {
        let httpController = AuthHttpController.instance
        let successExcpectation = expectation(description: "request success")

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
            parameters: parameters,
            onSuccess: { (code, authResult: AuthResult?) in
                //
            },
            onError: { error, code, authError in
                XCTAssertEqual(authError?.error, .invalidClient)
                successExcpectation.fulfill()
            }
        )
        waitForExpectations(timeout: 20.0, handler: nil)
    }
    
    func test_request_shouldFailWithInvalidRequest() {
        let httpController = AuthHttpController.instance
        let successExcpectation = expectation(description: "request success")

        guard
            let realm = serviceRealm,
            let authUrl = URL(string: "/auth/realms/\(realm)/protocol/openid-connect/token", relativeTo: url)
        else {
            return
        }
        httpController.request(
            url: authUrl,
            method: .post,
            onSuccess: { (code, authResult: AuthResult?) in
                //
            },
            onError: { error, code, authError in
                XCTAssertEqual(authError?.error, .invalidRequest)
                successExcpectation.fulfill()
            }
        )
        waitForExpectations(timeout: 20.0, handler: nil)
    }
}
