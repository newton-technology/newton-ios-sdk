//
//  AuthError.swift
//  
//
//  Created by Mihail Kuznetsov on 28.04.2021.
//

enum AuthErrorCode: String, Decodable {
    case unsupportedGrantType = "unsupported_grant_type"
    case invalidClient = "invalid_client"
    case invalidRequest = "invalid_request"
    case invalidToken = "invalid_token"
    case notAllowed = "not_allowed"
    case invalidGrant = "invalid_grant"
    case passwordMissing = "password_missing"
    case phoneMissing = "phone_missing"
    case invalidPhone = "invalid_phone"
    case codeMissing = "code_missing"
    case usernameMissing = "username_missing"
    case usernameInUse = "username_in_use"
    case emailInUse = "email_in_use"
    case realmDisabled = "realm_disabled"
    case unknownError = "unknown_error"
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
