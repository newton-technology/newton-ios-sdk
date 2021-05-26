//
//  AuthFlow.swift
//  
//
//  Created by Mihail Kuznetsov on 21.05.2021.
//

import Foundation

public enum LoginFlow: String, Decodable {
    case short = "SHORT"
    case normal = "NORMAL"
    case normalWithEmail = "NORMAL_WITH_EMAIL"
}

public enum LoginStep: String, Decodable {
    case sendPhoneCode = "SEND_PHONE_CODE"
    case verifyPhoneCode = "VERIFY_PHONE_CODE"
    case sendEmailCode = "SEND_EMAIL_CODE"
    case verifyEmailCode = "VERIFY_EMAIL_CODE"
    case getMainToken = "GET_MAIN_TOKEN"
}

public struct AuthFlowState: Decodable {
    public let loginFlow: LoginFlow
    public let loginStep: LoginStep
    public let phoneNumber: String?
    public let maskedEmail: String?
    
    enum CodingKeys: String, CodingKey {
        case loginFlow = "login_flow"
        case loginStep = "login_step"
        case phoneNumber = "phone_number"
        case maskedEmail = "masked_email"
    }
}
