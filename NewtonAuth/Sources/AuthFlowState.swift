//
//  AuthFlow.swift
//  
//
//  Created by Mihail Kuznetsov on 21.05.2021.
//

import Foundation
import SwiftUI

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
public class AuthFlowStateDecodable: Decodable {
    /// Current login flow
    public let loginFlow: LoginFlow
    /// Current login step
    public let loginStep: LoginStep
    /// User phone number
    public let phoneNumber: String?
    /// Masked email value
    public let maskedEmail: String?
    /// Timestamp when code can be resubmitted
    public let codeCanBeResubmittedTimestampFromData: TimeInterval?
    /// Timestamp when code expires
    public let codeExpiresTimestampFromData: TimeInterval?
    /// OTP checks left
    public let otpChecksLeft: Int?
    /// OTP sends left
    public let otpSendsLeft: Int?
    
    enum CodingKeys: String, CodingKey {
        case loginFlow = "login_flow"
        case loginStep = "login_step"
        case phoneNumber = "phone_number"
        case maskedEmail = "masked_email"
        case codeCanBeResubmittedTimestampFromData = "code_can_be_resubmitted_timestamp"
        case codeExpiresTimestampFromData = "code_expires_timestamp"
        case otpChecksLeft = "otp_checks_left"
        case otpSendsLeft = "otp_sends_left"
    }
}

public class AuthFlowState: AuthFlowStateDecodable {
    
    /// Timestamp when code can be resubmitted
    public private(set) var codeCanBeResubmittedTimestamp: TimeInterval?
    /// Timestamp when code expires
    public private(set) var codeExpiresTimestamp: TimeInterval?
    
    public required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        codeCanBeResubmittedTimestamp = self.codeCanBeResubmittedTimestampFromData
        codeExpiresTimestamp = self.codeCanBeResubmittedTimestampFromData
    }
    
    public static func getAuthFlowStateWithHeaderData(flowStateData: Data?, headerData: [AnyHashable: Any]?) -> AuthFlowState?{
        guard let data = flowStateData else {
            return nil
        }
        do {
            let authFlowState = try JSONDecoder().decode(AuthFlowState.self, from: data)
            authFlowState.updateExpirationTimestamps(with: headerData)
            return authFlowState
        } catch {
            return nil
        }
    }
    
    private func updateExpirationTimestamps(with headerData: [AnyHashable: Any]?) {
        self.codeExpiresTimestamp = TimestampUtils.getExpirationTimeInSeconds(timestampInSeconds: self.codeExpiresTimestampFromData, httpHeaders: headerData)
        self.codeCanBeResubmittedTimestamp = TimestampUtils.getExpirationTimeInSeconds(timestampInSeconds: self.codeCanBeResubmittedTimestampFromData, httpHeaders: headerData)
    }
    
}
