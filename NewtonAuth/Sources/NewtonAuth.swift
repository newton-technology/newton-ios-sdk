//
//  NewtonAuth.swift
//  
//
//  Created by Mihail Kuznetsov on 15.04.2021.
//

import Foundation

public func authentication(url: String, clientId: String, realm: String, serviceRealm: String) -> NewtonAuthentication {
    let urlString: String
    if !url.hasPrefix("https") {
        urlString = "https://\(url)"
    } else {
        urlString = url
    }
    let urlValue = URL(string: urlString)!
    return NewtonAuthentication(url: urlValue, clientId: clientId, realm: realm, serviceRealm: serviceRealm)
}

public func decodeJWT(jwtToken: String) -> [String: Any]? {
    return JWTUtils.decode(jwtToken: jwtToken)
}

public func decodeAuthFlowState(jwtToken: String) -> AuthFlowState? {
    return JWTUtils.decodeAuthFlowState(jwtToken: jwtToken)
}
