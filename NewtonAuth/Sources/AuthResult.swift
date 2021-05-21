//
//  AuthResult.swift
//  
//
//  Created by Mihail Kuznetsov on 28.04.2021.
//

public struct AuthResult: Decodable {
    let accessToken: String
    let accessTokenExpiresIn: Int
    let refreshToken: String
    let refreshTokenExpiresIn: Int
    let tokenType: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case accessTokenExpiresIn = "expires_in"
        case refreshToken = "refresh_token"
        case refreshTokenExpiresIn = "refresh_expires_in"
        case tokenType = "token_type"
    }
}
