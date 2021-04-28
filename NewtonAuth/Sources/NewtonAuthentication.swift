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

    public init(url: URL, clientId: String, realm: String) {
        self.url = url
        self.clientId = clientId
        self.realm = realm
    }

    public func requestOtp(withPhoneNumber phoneNumber: String) {
        let httpController = AuthHttpController.instance
        
        guard let requestUrl = URL(string: "/auth/realms/\(realm)/protocol/openid-connect/token", relativeTo: url) else {
            return
        }
        
        httpController.request(
            url: requestUrl,
            method: .post,
            parameters: [
                "grant_type": "password",
                "client_id": clientId,
                "phone_number": phoneNumber
            ]
        )
    }
    
    public func confirmOtp(accessToken: String, code: String) {
        let httpController = AuthHttpController.instance
        
        guard let requestUrl = URL(string: "/auth/realms/\(realm)/protocol/openid-connect/token", relativeTo: url) else {
            return
        }
        
        httpController.request(
            url: requestUrl,
            method: .post,
            headers: [
                "Authorization": "Bearer \(accessToken)"
            ],
            parameters: [
                "grant_type": "password",
                "client_id": clientId,
                "code": code
            ]
        )
    }
    
    public func login(accessToken: String, password: String?) {
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
            headers: [
                "Authorization": "Bearer \(accessToken)"
            ],
            parameters: parameters
        )
    }

}
