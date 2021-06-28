//
//  AuthResult.swift
//  
//
//  Created by Mihail Kuznetsov on 28.04.2021.
//

// Newton authentication success result
public struct AuthResult: Decodable {
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
