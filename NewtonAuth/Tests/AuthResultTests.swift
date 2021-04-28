//
//  File.swift
//  
//
//  Created by Mihail Kuznetsov on 28.04.2021.
//

import XCTest
@testable import NewtonAuth

final class AuthResultTests: XCTestCase {
    
    func test_decode_shouldBeValid() throws {
        let result = try JSONDecoder().decode(AuthResult.self, from: KeycloakAuthResult)
        XCTAssertEqual(result.accessTokenExpiresIn, 300)
        XCTAssertEqual(result.refreshTokenExpiresIn, 1800)
        XCTAssertEqual(result.tokenType, "Bearer")
    }
    
    func test_decode_whenMissingAttributes_itThrows() {
        XCTAssertThrowsError(try JSONDecoder().decode(AuthResult.self, from: KeycloakAuthResultWithMissingToken)) { error in
            if case .keyNotFound(let key, _)? = error as? DecodingError {
                XCTAssertEqual("access_token", key.stringValue)
            } else {
                XCTFail("Expected '.keyNotFound' but got \(error)")
            }
        }
    }
    
}

private let KeycloakAuthResult = Data("""
    {
        "access_token": "eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJ6Q2NVS1NRN3JZNkJNSVRWcDFzS09lejJUVE8tcElESGZLWW1EVmlnZEJNIn0.eyJleHAiOjE2MTk2MDExNTIsImlhdCI6MTYxOTYwMDg1MiwianRpIjoiMDUxOWY4NzgtNzAxMC00MTc0LTgxNWEtYTFkN2M2NGQwNzg5IiwiaXNzIjoiaHR0cHM6Ly9rZXljbG9hay5uZXd0b24tdGVjaG5vbG9neS5ydS9hdXRoL3JlYWxtcy9zZXJ2aWNlIiwiYXVkIjoiYWNjb3VudCIsInN1YiI6InBob25lOis3OTIyMjcyMzQyNyIsInR5cCI6IkJlYXJlciIsImF6cCI6InRlemlzIiwic2Vzc2lvbl9zdGF0ZSI6IjEwMjFiOTU4LTgyZmMtNDQwNS04MzZhLWVmZDE3MDEzM2JjNCIsInBob25lX251bWJlciI6Iis3OTIyMjcyMzQyNyIsImFjciI6IjEiLCJhbGxvd2VkLW9yaWdpbnMiOlsiLyoiXSwicmVhbG1fYWNjZXNzIjp7InJvbGVzIjpbIm9mZmxpbmVfYWNjZXNzIiwidW1hX2F1dGhvcml6YXRpb24iXX0sInJlc291cmNlX2FjY2VzcyI6eyJhY2NvdW50Ijp7InJvbGVzIjpbIm1hbmFnZS1hY2NvdW50IiwibWFuYWdlLWFjY291bnQtbGlua3MiLCJ2aWV3LXByb2ZpbGUiXX19LCJzY29wZSI6IiJ9.EQ-lUJ-UEmfLafDzcHvgpdfPEdZGU1r-_3w7oltoMY7zzqshz-3CsGmnljJ9iY8bn6vWUaSyNWyIt7e7q5Q4Hq1OFrgOpEQia8w0tsDXTyobryIuhPp_ROk3GyQWULLR_7780Fl1FsfJYp04z9-IrdMlrIHua56Rd-inapJh9se1M2oIPsNMvI593fkJq1r6srrHCLaT9U1zqR4WxX4EMhQiWqDJmGGaOVVi1Ovza89FqCLzADTxMYD2I7N0QqnKMr1YNzM_8hYBnCgsZrAbd64pol8vnlTwkHaFzFPti86UZCVKjss3TLhH9ytwHpMZBdNCJyzRkBYZusYHL2XLgA",
        "expires_in": 300,
        "refresh_expires_in": 1800,
        "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICI1NjQ3YTU4Yy1jNmJjLTQ4ODYtOGM4NC1lMDY4MjVhNjhjMzYifQ.eyJleHAiOjE2MTk2MDI2NTIsImlhdCI6MTYxOTYwMDg1MiwianRpIjoiYTc3MGQxM2YtZDA5OC00ZjZhLThjYjUtYTM0OThmMzk1MWFkIiwiaXNzIjoiaHR0cHM6Ly9rZXljbG9hay5uZXd0b24tdGVjaG5vbG9neS5ydS9hdXRoL3JlYWxtcy9zZXJ2aWNlIiwiYXVkIjoiaHR0cHM6Ly9rZXljbG9hay5uZXd0b24tdGVjaG5vbG9neS5ydS9hdXRoL3JlYWxtcy9zZXJ2aWNlIiwic3ViIjoicGhvbmU6Kzc5MjIyNzIzNDI3IiwidHlwIjoiUmVmcmVzaCIsImF6cCI6InRlemlzIiwic2Vzc2lvbl9zdGF0ZSI6IjEwMjFiOTU4LTgyZmMtNDQwNS04MzZhLWVmZDE3MDEzM2JjNCIsInNjb3BlIjoiIn0.giDqjh-7LgOOR9h_Mgeu6_E_4llyaM456miJp_oPRgE",
        "token_type": "Bearer"
    }
""".utf8)

private let KeycloakAuthResultWithMissingToken = Data("""
    {
        "expires_in": 300,
        "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICI1NjQ3YTU4Yy1jNmJjLTQ4ODYtOGM4NC1lMDY4MjVhNjhjMzYifQ.eyJleHAiOjE2MTk2MDI2NTIsImlhdCI6MTYxOTYwMDg1MiwianRpIjoiYTc3MGQxM2YtZDA5OC00ZjZhLThjYjUtYTM0OThmMzk1MWFkIiwiaXNzIjoiaHR0cHM6Ly9rZXljbG9hay5uZXd0b24tdGVjaG5vbG9neS5ydS9hdXRoL3JlYWxtcy9zZXJ2aWNlIiwiYXVkIjoiaHR0cHM6Ly9rZXljbG9hay5uZXd0b24tdGVjaG5vbG9neS5ydS9hdXRoL3JlYWxtcy9zZXJ2aWNlIiwic3ViIjoicGhvbmU6Kzc5MjIyNzIzNDI3IiwidHlwIjoiUmVmcmVzaCIsImF6cCI6InRlemlzIiwic2Vzc2lvbl9zdGF0ZSI6IjEwMjFiOTU4LTgyZmMtNDQwNS04MzZhLWVmZDE3MDEzM2JjNCIsInNjb3BlIjoiIn0.giDqjh-7LgOOR9h_Mgeu6_E_4llyaM456miJp_oPRgE",
        "refresh_expires_in": 1800,
        "token_type": "Bearer"
    }
""".utf8)

