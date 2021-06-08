//
//  AuthFlow.swift
//  
//
//  Created by Mihail Kuznetsov on 21.05.2021.
//

import Foundation

/// Current login flow
public enum LoginFlow: String, Decodable {
    /// Short login flow with phone number and one-time code
    case short = "SHORT"
    /// Normal login flow with phone number, one-time code and user password
    case normal = "NORMAL"
    /// Normal login flow with phone number and one-time code which requires user to create new password after confirming identity through email code
    case normalWithEmail = "NORMAL_WITH_EMAIL"
}

/// Current login step
public enum LoginStep: String, Decodable {
    /// Request a one-time code with phone
    case sendPhoneCode = "SEND_PHONE_CODE"
    /// Verify one-time code sent to user phone number
    case verifyPhoneCode = "VERIFY_PHONE_CODE"
    /// Request a one-time code for email
    case sendEmailCode = "SEND_EMAIL_CODE"
    /// Verify one-time code sent to user email
    case verifyEmailCode = "VERIFY_EMAIL_CODE"
    /// Request a token pair from main realm
    case getMainToken = "GET_MAIN_TOKEN"
}

/// Current authorization flow state
public struct AuthFlowState: Decodable {
    /// Current login flow
    public let loginFlow: LoginFlow
    /// Current login step
    public let loginStep: LoginStep
    /// User phone number
    public let phoneNumber: String?
    /// Masked email value
    public let maskedEmail: String?
    
    enum CodingKeys: String, CodingKey {
        case loginFlow = "login_flow"
        case loginStep = "login_step"
        case phoneNumber = "phone_number"
        case maskedEmail = "masked_email"
    }
}
