//
//  AuthError.swift
//  
//
//  Created by Mihail Kuznetsov on 28.04.2021.
//

enum AuthErrorCode: String, Decodable {
    case unsupportedGrantType = "unsupported_grant_type"
    case unknownError
}

extension AuthErrorCode {
    init(from decoder: Decoder) throws {
        self = try AuthErrorCode(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknownError
    }
}

public struct AuthError: Decodable {
    let error: AuthErrorCode
    let errorDescription: String?
    
    enum CodingKeys: String, CodingKey {
        case error = "error"
        case errorDescription = "error_description"
    }
}
