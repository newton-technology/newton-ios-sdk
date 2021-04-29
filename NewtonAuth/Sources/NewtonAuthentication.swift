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

    public func requestOtp(
        withPhoneNumber phoneNumber: String,
        onSuccess: ((_ authResult: AuthResult) -> Void)? = nil,
        onError: ((_ authError: AuthError?) -> Void)? = nil
    ) {
        let httpController = AuthHttpController.instance
        
        guard let requestUrl = URL(string: "/auth/realms/\(serviceRealm)/protocol/openid-connect/token", relativeTo: url) else {
            return
        }
        
        httpController.request(
            url: requestUrl,
            method: .post,
            resultModel: AuthResult.self,
            parameters: [
                "grant_type": "password",
                "client_id": clientId,
                "phone_number": phoneNumber
            ],
            onSuccess: { (code, authResult: AuthResult?) in
                guard let successHandler = onSuccess, let result = authResult else { return }
                successHandler(result)
            },
            onError: { error, code, authError in
                guard let errorHandler = onError, let error = authError else { return }
                errorHandler(error)
            }
        )
    }
    
    public func confirmOtp(
        accessToken: String,
        code: String,
        onSuccess: ((_ authResult: AuthResult) -> Void)? = nil,
        onError: ((_ authError: AuthError?) -> Void)? = nil
    ) {
        let httpController = AuthHttpController.instance
        
        guard let requestUrl = URL(string: "/auth/realms/\(serviceRealm)/protocol/openid-connect/token", relativeTo: url) else {
            return
        }
        
        httpController.request(
            url: requestUrl,
            method: .post,
            resultModel: AuthResult.self,
            headers: [
                "Authorization": "Bearer \(accessToken)"
            ],
            parameters: [
                "grant_type": "password",
                "client_id": clientId,
                "code": code
            ],
            onSuccess: { (code, authResult: AuthResult?) in
                guard let successHandler = onSuccess, let result = authResult else { return }
                successHandler(result)
            },
            onError: { error, code, authError in
                guard let errorHandler = onError, let error = authError else { return }
                errorHandler(error)
            }
        )
    }
    
    public func login(
        accessToken: String,
        password: String?,
        onSuccess: ((_ authResult: AuthResult) -> Void)? = nil,
        onError: ((_ authError: AuthError?) -> Void)? = nil
    ) {
        let httpController = AuthHttpController.instance
        
        guard let requestUrl = URL(string: "/auth/realms/\(realm)/protocol/openid-connect/token", relativeTo: url) else {
            return
        }
        
        var parameters = [
            "grant_type": "password",
            "client_id": clientId
        ]
        if password != nil {
            parameters["password"] = password
        }
        
        httpController.request(
            url: requestUrl,
            method: .post,
            resultModel: AuthResult.self,
            headers: [
                "Authorization": "Bearer \(accessToken)"
            ],
            parameters: parameters,
            onSuccess: { (code, authResult: AuthResult?) in
                guard let successHandler = onSuccess, let result = authResult else { return }
                successHandler(result)
            },
            onError: { error, code, authError in
                guard let errorHandler = onError, let error = authError else { return }
                errorHandler(error)
            }
        )
    }

}
