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
    /// One time password attemtps exceeded
    case attemptsOtpCheckExceeded = "attempts_otp_check_exceeded"
    /// Password is blacklisted
    case invalidPasswordBlacklisted = "invalid_password_blacklisted"
    /// Password has too few digits
    case invalidPasswordMinDigits = "invalid_password_min_digits"
    /// Password was recently used
    case invalidPasswordHistory = "invalid_password_history"
    /// Password if too short
    case invalid_password_min_length = "invalid_password_min_length"
    /// Password has too few lower case chars
    case invalidPasswordMinLowerCaseChars = "invalid_password_min_lower_case_chars"
    /// Password is too long
    case invalidPasswordMaxLength = "invalid_password_max_length"
    /// Password equals email
    case invalidPasswordNotEmail = "invalid_password_not_email"
    /// Password equals username
    case invalidPasswordNotUsername = "invalid_password_not_username"
    /// Invalid password regex pattern
    case invalidPasswordRegexPattern = "invalid_password_regex_pattern"
    /// Password has too few special symbols
    case invalidPasswordMinSpecialChars = "invalid_password_min_special_chars"
    /// Password has too few uppercase symbols
    case invalidPasswordMinUpperCaseChars = "invalid_password_min_upper_case_chars"
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
    /// Authentication otp checks left
    public let otpChecksLeft: Int?
    /// Authentication otp sends left
    public let otpSendsLeft: Int?
    
    enum CodingKeys: String, CodingKey {
        case error = "error"
        case errorDescription = "error_description"
        case otpChecksLeft = "otp_checks_left"
        case otpSendsLeft = "otp_sends_left"
    }
}
