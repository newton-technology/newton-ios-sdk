//
//  NewtonAuth.swift
//  
//
//  Created by Mihail Kuznetsov on 15.04.2021.
//

import Foundation

/**
 Newton Authentication API to authenticate user
 
 ```
 NewtonAuth.authentication(url: "sample.newton.auth.com", clientId: "sampleClient", realm: "main", servceRealm: "service")
 ```

 - parameter url: url of Newton Keycloak server
 - parameter clientId: client_id of Kecloak server
 - parameter realm: name of a main relam of Newton Keycloak server
 - parameter serviceRealm: name of a service realm of Newton Keycloak server
 
 - returns NewtonAuthentication
 */
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

/**
 Decode JSON web token
 ```
 NewtonAuth.decodeJWT(jwt: VALID_JWT)
 ```
 
 - parameter jwt: a JSON web token string
 
 - returns JWT decoded into a dictionary
 */
public func decodeJWT(jwtToken: String) -> [String: Any]? {
    return JWTUtils.decode(jwtToken: jwtToken)
}

/**
 Decode Auth flow state from JWT
 
 - parameter jwt: JSON web token string
 
 - returns JWT decoded into a an Auth flow state object or nil if JWT is not a valid Newton Keycloak service token
 */
public func decodeAuthFlowState(jwtToken: String) -> AuthFlowState? {
    return JWTUtils.decodeAuthFlowState(jwtToken: jwtToken)
}
