//
//  AuthResult.swift
//  
//
//  Created by Mihail Kuznetsov on 28.04.2021.
//

import Foundation

// Newton authentication success result

public class AuthResultDecodable: Decodable {
    public let accessToken: String
    public let accessTokenExpiresIn: Int
    public let refreshToken: String
    public let refreshTokenExpiresIn: Int
    public let tokenType: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case accessTokenExpiresIn = "expires_in"
        case refreshToken = "refresh_token"
        case refreshTokenExpiresIn = "refresh_expires_in"
        case tokenType = "token_type"
    }
}

public class AuthResult: AuthResultDecodable {
    
    public private(set) var localExpirationTime: Double?

    private func updateWithHeadersData(headerData: [AnyHashable: Any]?) {
        let payload = JWTUtils.decode(jwtToken: self.accessToken)
        let exp = payload["exp"] as? Double
        localExpirationTime = TimestampUtils.getExpirationTimeInSeconds(timestampInSeconds: exp, httpHeaders: headerData)
    }
    
    public static func getAuthResultWithHeadersData(resultData: Data?, headerData: [AnyHashable: Any]?) -> AuthResult? {
        guard let data = resultData else {
            return nil
        }
        do {
            let authResult = try JSONDecoder().decode(AuthResult.self, from: data)
            authResult.updateWithHeadersData(headerData: headerData)
            return authResult
        } catch {
            return nil
        }
    }
}
