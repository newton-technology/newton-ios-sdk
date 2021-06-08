//
//  NewtonAuthentication.swift
//  
//
//  Created by Mihail Kuznetsov on 15.04.2021.
//

import Foundation

public struct NewtonAuthentication {
    
    private let url: URL
    private let clientId: String
    private let realm: String
    private let serviceRealm: String

    public init(url: URL, clientId: String, realm: String, serviceRealm: String) {
        self.url = url
        self.clientId = clientId
        self.realm = realm
        self.serviceRealm = serviceRealm
    }

    public func sendPhoneCode(
        phoneNumber: String,
        onSuccess successHandler: @escaping ((_ authResult: AuthResult, _ authFlowState: AuthFlowState?) -> Void),
        onError errorHandler: @escaping ((_ error: AuthError) -> Void)
    ) {
        let parameters = [
            "grant_type": "password",
            "client_id": clientId,
            "phone_number": phoneNumber
        ]
        return requestServiceToken(
            parameters: parameters,
            authorizationToken: nil,
            onSuccess: successHandler,
            onError: errorHandler
        )
    }
    
    public func verifyPhone(
        withCode code: String,
        previousAuthResult authResult: AuthResult,
        onSuccess successHandler: @escaping ((_ authResult: AuthResult, _ authFlowState: AuthFlowState?) -> Void),
        onError errorHandler: @escaping ((_ error: AuthError) -> Void)
    ) {
        return verifyPhone(withCode: code, serviceToken: authResult.accessToken, onSuccess: successHandler, onError: errorHandler)
    }
    
    public func verifyPhone(
        withCode code: String,
        serviceToken accessToken: String,
        onSuccess successHandler: @escaping ((_ authResult: AuthResult, _ authFlowState: AuthFlowState?) -> Void),
        onError errorHandler: @escaping ((_ error: AuthError) -> Void)
    ) {
        let parameters = [
            "grant_type": "password",
            "client_id": clientId,
            "code": code
        ]
        return requestServiceToken(
            parameters: parameters,
            authorizationToken: accessToken,
            onSuccess: successHandler,
            onError: errorHandler
        )
    }
    
    public func sendEmailCode(
        previousAuthResult authResult: AuthResult,
        onSuccess successHandler: @escaping ((_ authResult: AuthResult, _ authFlowState: AuthFlowState?) -> Void),
        onError errorHandler: @escaping ((_ error: AuthError) -> Void)
    ) {
        return sendEmailCode(serviceToken: authResult.accessToken, onSuccess: successHandler, onError: errorHandler)
    }
    
    public func sendEmailCode(
        serviceToken accessToken: String,
        onSuccess successHandler: @escaping ((_ authResult: AuthResult, _ authFlowState: AuthFlowState?) -> Void),
        onError errorHandler: @escaping ((_ error: AuthError) -> Void)
    ) {
        let parameters = [
            "grant_type": "password",
            "client_id": clientId
        ]
        return requestServiceToken(
            parameters: parameters,
            authorizationToken: accessToken,
            onSuccess: successHandler,
            onError: errorHandler
        )
    }
    
    public func verifyEmail(
        withEmailCode code: String,
        previousAuthResult authResult: AuthResult,
        onSuccess successHandler: @escaping ((_ authResult: AuthResult, _ authFlowState: AuthFlowState?) -> Void),
        onError errorHandler: @escaping ((_ error: AuthError) -> Void)
    ) {
        return verifyEmail(withEmailCode: code, serviceToken: authResult.accessToken, onSuccess: successHandler, onError: errorHandler)
    }
    
    public func verifyEmail(
        withEmailCode code: String,
        serviceToken accessToken: String,
        onSuccess successHandler: @escaping ((_ authResult: AuthResult, _ authFlowState: AuthFlowState?) -> Void),
        onError errorHandler: @escaping ((_ error: AuthError) -> Void)
    ) {
        let parameters = [
            "grant_type": "password",
            "client_id": clientId,
            "code": code
        ]
        return requestServiceToken(
            parameters: parameters,
            authorizationToken: accessToken,
            onSuccess: successHandler,
            onError: errorHandler
        )
    }
    
    public func login(
        withAuthResult authResult: AuthResult,
        onSuccess successHandler: @escaping ((_ authResult: AuthResult) -> Void),
        onError errorHandler: @escaping ((_ error: AuthError) -> Void)
    ) {
        return login(withServiceToken: authResult.accessToken, password: nil, onSuccess: successHandler, onError: errorHandler)
    }
    
    public func login(
        withAuthResult authResult: AuthResult,
        password: String?,
        onSuccess successHandler: @escaping ((_ authResult: AuthResult) -> Void),
        onError errorHandler: @escaping ((_ error: AuthError) -> Void)
    ) {
        return login(withServiceToken: authResult.accessToken, password: password, onSuccess: successHandler, onError: errorHandler)
    }
    
    public func login(
        withServiceToken token: String,
        onSuccess successHandler: @escaping ((_ authResult: AuthResult) -> Void),
        onError errorHandler: @escaping ((_ error: AuthError) -> Void)
    ) {
        return login(withServiceToken: token, password: nil, onSuccess: successHandler, onError: errorHandler)
    }
    
    public func login(
        withServiceToken token: String,
        password: String?,
        onSuccess successHandler: @escaping ((_ authResult: AuthResult) -> Void),
        onError errorHandler: @escaping ((_ error: AuthError) -> Void)
    ) {
        var parameters = [
            "grant_type": "password",
            "client_id": clientId
        ]
        if let password = password {
            parameters["password"] = password
        }
        return requestMainToken(
            parameters: parameters,
            authorizationToken: token,
            onSuccess: successHandler,
            onError: errorHandler
        )
    }
    
    public func refreshToken(
        refreshToken: String,
        onSuccess successHandler: @escaping ((_ authResult: AuthResult) -> Void),
        onError errorHandler: @escaping ((_ error: AuthError) -> Void)
    ) {
        let parameters = [
            "client_id": clientId,
            "grant_type": "refresh_token",
            "refresh_token": refreshToken
        ]
        return requestMainToken(
            parameters: parameters,
            authorizationToken: nil,
            onSuccess: successHandler,
            onError: errorHandler
        )
    }

    private func requestServiceToken(
        parameters: [String: Any],
        authorizationToken: String?,
        onSuccess successHandler: @escaping ((_ authResult: AuthResult, _ authFlowState: AuthFlowState?) -> Void),
        onError errorHandler: @escaping ((_ error: AuthError) -> Void)
    ) {
        return requestAccessToken(
            realm: serviceRealm,
            parameters: parameters,
            authorizationToken: authorizationToken,
            onSuccess: successHandler,
            onError: errorHandler
        )
    }
    
    private func requestMainToken(
        parameters: [String: Any],
        authorizationToken: String?,
        onSuccess successHandler: @escaping ((_ authResult: AuthResult) -> Void),
        onError errorHandler: @escaping ((_ error: AuthError) -> Void)
    ) {
        return requestAccessToken(
            realm: realm,
            parameters: parameters,
            authorizationToken: authorizationToken,
            onSuccess: { result, _ in
                successHandler(result)
            },
            onError: errorHandler
        )
    }

    private func requestAccessToken(
        realm: String,
        parameters: [String: Any],
        authorizationToken: String?,
        onSuccess successHandler: @escaping ((_ authResult: AuthResult, _ authFlowState: AuthFlowState?) -> Void),
        onError errorHandler: @escaping ((_ error: AuthError) -> Void)
    ) {
        let httpController = AuthHttpController.instance
        
        guard let requestUrl = URL(string: "/auth/realms/\(realm)/protocol/openid-connect/token", relativeTo: url) else {
            return
        }
        var headers: [String: String]? = nil
        if let token = authorizationToken {
            headers = ["Authorization": "Bearer \(token)"]
        }
        httpController.request(
            url: requestUrl,
            method: .post,
            resultModel: AuthResult.self,
            headers: headers,
            parameters: parameters,
            onSuccess: { (code, authResult: AuthResult?) in
                guard let result = authResult else {
                    errorHandler(AuthError(error: .unknownError, errorDescription: nil))
                    return
                }
                let flowState = JWTUtils.decodeAuthFlowState(jwtToken: result.accessToken)
                successHandler(result, flowState)
            },
            onError: { error, code, authError in
                guard let error = authError else {
                    errorHandler(AuthError(error: .unknownError, errorDescription: nil))
                    return
                }
                if error.error == .invalidGrant, let token = authorizationToken, JWTUtils.jwtExpired(jwt: token) {
                    errorHandler(AuthError(error: .tokenExpired, errorDescription: "Auth token expired"))
                    return
                }
                errorHandler(error)
            }
        )
    }

}
