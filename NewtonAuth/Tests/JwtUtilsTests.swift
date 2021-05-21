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
        XCTAssertEqual(authFlowData.loginFlow, .short)
        XCTAssertEqual(authFlowData.loginStep, .verifyPhoneCode)
    }

}


private let validToken = """
    eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJ6Q2NVS1NRN3JZNkJNSVRWcDFzS09lejJUVE8tcElESGZLWW1EVmlnZEJNIn0.eyJleHAiOjE2MjE1ODcyMTgsImlhdCI6MTYyMTU4NjkxOCwianRpIjoiYjQxNjgzZDQtYWQ3NC00NThmLTkxOWItMWYxYTA0ZDBjMGJiIiwiaXNzIjoiaHR0cHM6Ly9rZXljbG9hay5uZXd0b24tdGVjaG5vbG9neS5ydS9hdXRoL3JlYWxtcy9zZXJ2aWNlIiwiYXVkIjoiYWNjb3VudCIsInN1YiI6InBob25lOis3OTIyMjcyMzQyNyIsInR5cCI6IkJlYXJlciIsImF6cCI6InRlemlzIiwic2Vzc2lvbl9zdGF0ZSI6ImUwYTBiNzUzLTJkNGUtNGY4OS1hZTUyLTU3ZGEzY2FjYjJhYSIsInBob25lX251bWJlciI6Iis3OTIyMjcyMzQyNyIsImFjciI6IjEiLCJhbGxvd2VkLW9yaWdpbnMiOlsiLyoiXSwicmVhbG1fYWNjZXNzIjp7InJvbGVzIjpbIm9mZmxpbmVfYWNjZXNzIiwidW1hX2F1dGhvcml6YXRpb24iXX0sInJlc291cmNlX2FjY2VzcyI6eyJhY2NvdW50Ijp7InJvbGVzIjpbIm1hbmFnZS1hY2NvdW50IiwibWFuYWdlLWFjY291bnQtbGlua3MiLCJ2aWV3LXByb2ZpbGUiXX19LCJzY29wZSI6IiIsImxvZ2luX3N0ZXAiOiJWRVJJRllfUEhPTkVfQ09ERSIsImxvZ2luX2Zsb3ciOiJTSE9SVCJ9.tqtf2YsIQBn2fC2UijU46o5rOtPLdUHf4VnaX7A2k6Vl2it-bNprBxXOQn-jaqfJcOO9XRVF2FUumYRl-ovgUhk7qZNYYZMyOzKwgnei4gQCEJiu_tmNci1dBiLyzccKk0doTzT27sGveoZ0jiOKjNLlRN--j8KOsswyhOknc6HpSMWFE2tnrVLlCJ21bEYmSP0yBFq-qRvxFQEmUVFrzeFHMfgiBVZZk3LMiIipkWtEpvaJgCIQo1SX9ald8Z04DXZJmnEERXsCd3Jb3e7oPOTzpFuLd4-9Wm4PZYcVeX5yyzefdTDYJaQI_0tt4kcqhgwUj5c5fvZZNww7xrlrDQ
"""
