//
//  AuthFlow.swift
//  
//
//  Created by Mihail Kuznetsov on 21.05.2021.
//

import Foundation

enum LoginFlow: String, Decodable {
    case short = "SHORT"
    case normal = "NORMAL"
    case normalWithEmail = "NORMAL_WITH_EMAIL"
}

enum LoginStep: String, Decodable {
    case sendPhoneCode = "SEND_PHONE_CODE"
    case verifyPhoneCode = "VERIFY_PHONE_CODE"
    case sendEmailCode = "SEND_EMAIL_CODE"
    case verifyEmailCode = "VERIFY_EMAIL_CODE"
    case getMainToken = "GET_MAIN_TOKEN"
}

public struct AuthFlowState: Decodable {
    let loginFlow: LoginFlow
    let loginStep: LoginStep
    let maskedEmail: String?
    
    enum CodingKeys: String, CodingKey {
        case loginFlow = "login_flow"
        case loginStep = "login_step"
        case maskedEmail = "masked_email"
    }
}
