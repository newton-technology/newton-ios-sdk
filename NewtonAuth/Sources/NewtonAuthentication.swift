//
//  NewtonAuthentication.swift
//  
//
//  Created by Mihail Kuznetsov on 15.04.2021.
//

import Foundation

public struct NewtonAuthentication {
    
    let url: URL
    let clientId: String
    let realm: String
    let serviceRealm: String

    public init(url: URL, clientId: String, realm: String, serviceRealm: String) {
        self.url = url
        self.clientId = clientId
        self.realm = realm
        self.serviceRealm = serviceRealm
    }

    public func sendPhoneCode(
        phoneNumber: String,
        completionHandler: AuthCompletionHandler
    ) {
        let parameters = [
            "grant_type": "password",
            "client_id": clientId,
            "phone_number": phoneNumber
        ]
        return requestServiceToken(parameters: parameters, completionHandler: completionHandler)
    }
    
    public func verifyPhone(
        withCode code: String,
        previousAuthResult authResult: AuthResult,
        completionHandler: AuthCompletionHandler
    ) {
        return verifyPhone(withCode: code, serviceToken: authResult.accessToken, completionHandler: completionHandler)
    }
    
    public func verifyPhone(
        withCode code: String,
        serviceToken accessToken: String,
        completionHandler: AuthCompletionHandler
    ) {
        let headers = [
            "Authorization": "Bearer \(accessToken)"
        ]
        let parameters = [
            "grant_type": "password",
            "client_id": clientId,
            "code": code
        ]
        return requestServiceToken(parameters: parameters, headers: headers, completionHandler: completionHandler)
    }
    
    public func sendEmailCode(
        previousAuthResult authResult: AuthResult,
        completionHandler: AuthCompletionHandler
    ) {
        return sendEmailCode(serviceToken: authResult.accessToken, completionHandler: completionHandler)
    }
    
    public func sendEmailCode(
        serviceToken accessToken: String,
        completionHandler: AuthCompletionHandler
    ) {
        let headers = [
            "Authorization": "Bearer \(accessToken)"
        ]
        let parameters = [
            "grant_type": "password",
            "client_id": clientId
        ]
        return requestServiceToken(parameters: parameters, headers: headers, completionHandler: completionHandler)
    }
    
    public func verifyEmail(
        withEmailCode code: String,
        previousAuthResult authResult: AuthResult,
        completionHandler: AuthCompletionHandler
    ) {
        return verifyEmail(withEmailCode: code, serviceToken: authResult.accessToken, completionHandler: completionHandler)
    }
    
    public func verifyEmail(
        withEmailCode code: String,
        serviceToken accessToken: String,
        completionHandler: AuthCompletionHandler
    ) {
        let headers = [
            "Authorization": "Bearer \(accessToken)"
        ]
        let parameters = [
            "grant_type": "password",
            "client_id": clientId,
            "code": code
        ]
        return requestServiceToken(parameters: parameters, headers: headers, completionHandler: completionHandler)
    }
    
    public func login(byAuthResult authResult: AuthResult, completionHandler: AuthCompletionHandler) {
        return login(byServiceToken: authResult.accessToken, withPassword: nil, completionHandler: completionHandler)
    }
    
    public func login(byAuthResult authResult: AuthResult, withPassword password: String?, completionHandler: AuthCompletionHandler) {
        return login(byServiceToken: authResult.accessToken, withPassword: password, completionHandler: completionHandler)
    }
    
    public func login(byServiceToken token: String, completionHandler: AuthCompletionHandler) {
        return login(byServiceToken: token, withPassword: nil, completionHandler: completionHandler)
    }
    
    public func login(byServiceToken token: String, withPassword password: String?, completionHandler: AuthCompletionHandler) {
        let headers = [
            "Authorization": "Bearer \(token)"
        ]
        var parameters = [
            "grant_type": "password",
            "client_id": clientId
        ]
        if let password = password {
            parameters["password"] = password
        }
        return requestMainToken(parameters: parameters, headers: headers, completionHandler: completionHandler)
    }

    private func requestServiceToken(
        parameters: [String: Any],
        headers: [String: String]?,
        completionHandler: AuthCompletionHandler
    ) {
        return requestAccessToken(realm: serviceRealm, parameters: parameters, headers: headers, completionHandler: completionHandler)
    }
    
    private func requestServiceToken(
        parameters: [String: Any],
        completionHandler: AuthCompletionHandler
    ) {
        return requestServiceToken(parameters: parameters, headers: nil, completionHandler: completionHandler)
    }
    
    private func requestMainToken(
        parameters: [String: Any],
        headers: [String: String]?,
        completionHandler: AuthCompletionHandler
    ) {
        return requestAccessToken(realm: realm, parameters: parameters, headers: headers, completionHandler: completionHandler)
    }

    
    private func requestAccessToken(
        realm: String,
        parameters: [String: Any],
        headers: [String: String]?,
        completionHandler: AuthCompletionHandler
    ) {
        let httpController = AuthHttpController.instance
        
        guard let requestUrl = URL(string: "/auth/realms/\(realm)/protocol/openid-connect/token", relativeTo: url) else {
            return
        }
        
        httpController.request(
            url: requestUrl,
            method: .post,
            resultModel: AuthResult.self,
            headers: headers,
            parameters: parameters,
            onSuccess: {(code, authResult: AuthResult?) in
                guard let result = authResult else {
                    completionHandler.onError(error: AuthError(error: .unknownError, errorDescription: nil))
                    return
                }
                let flowState = JWTUtils.decodeAuthFlowState(jwtToken: result.accessToken)
                completionHandler.onSuccess(authResult: result, authFlowState: flowState)
            },
            onError: { error, code, authError in
                guard let error = authError else {
                    completionHandler.onError(error: AuthError(error: .unknownError, errorDescription: nil))
                    return
                }
                completionHandler.onError(error: error)
            }
        )
    }
}
