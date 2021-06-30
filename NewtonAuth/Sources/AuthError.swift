//
//  AuthError.swift
//  
//
//  Created by Mihail Kuznetsov on 28.04.2021.
//

/// Code for authentication error
public enum AuthErrorCode: String, Decodable {
    /// Submitted grant type is not supported by the system
    case unsupportedGrantType = "unsupported_grant_type"
    /// Submitted client id is invalid
    case invalidClient = "invalid_client"
    /// Request is invalid
    case invalidRequest = "invalid_request"
    /// JWT is invalid
    case invalidToken = "invalid_token"
    /// Access denied
    case notAllowed = "not_allowed"
    /// Invalid password or verification code or access token has expired
    case invalidGrant = "invalid_grant"
    /// Password is missing in request
    case passwordMissing = "password_missing"
    /// Phone number is missing in request
    case phoneMissing = "phone_missing"
    /// Submitted phone number has invalid format
    case invalidPhone = "invalid_phone"
    /// Verification code is missing in requrest
    case codeMissing = "code_missing"
    /// Username is mssing in current request
    case usernameMissing = "username_missing"
    /// Registration username is already in use
    case usernameInUse = "username_in_use"
    /// Registration email is already in use
    case emailInUse = "email_in_use"
    /// Authentication realm is disabled
    case realmDisabled = "realm_disabled"
    /// Code was recently submitted
    case codeAlreadySubmitted = "code_already_submitted"
    ///JWT token expired
    case tokenExpired = "token_expired"
    /// Error is unknown
    case unknownError = "unknown_error"
    /// Server error
    case serverError = "server_error"
}

extension AuthErrorCode {
    public init(from decoder: Decoder) throws {
        self = try AuthErrorCode(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknownError
    }
}

/// Newton authentication error
public struct AuthError: Decodable {
    /// Authentication error code
    public let error: AuthErrorCode
    /// Authentication error description
    public let errorDescription: String?
    
    enum CodingKeys: String, CodingKey {
        case error = "error"
        case errorDescription = "error_description"
    }
}
