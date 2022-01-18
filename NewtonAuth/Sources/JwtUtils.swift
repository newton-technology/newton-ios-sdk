//
//  JwtUtils.swift
//  
//
//  Created by Mihail Kuznetsov on 21.05.2021.
//

import Foundation

class JWTUtils {

    /**
     Decode JSON web token
     ```
     decode(jwt: VALID_JWT)
     ```
     
     - parameter jwt: a JSON web token string
     
     - returns JWT decoded into a dictionary
     */
    public static func decode(jwtToken jwt: String) -> [String: Any] {
        let segments = jwt.components(separatedBy: ".")
        if (segments.count != 3) {
            // TODO: log warning
            return [:]
        }
        return decodeJWTPart(segments[1]) ?? [:]
    }
    
    /**
     Decode Auth flow state from JWT
     
     - parameter jwt: a JSON web token string
     
     - returns JWT decoded into a an Auth flow state object or nil if JWT is not a valid Newton Keycloak service token
     */
    public static func decodeAuthFlowState(
        jwtToken jwt: String,
        headerData: [AnyHashable: Any]?
    ) -> AuthFlowState? {
        let segments = jwt.components(separatedBy: ".")
        guard let bodyData = base64UrlDecode(segments[1]) else {
            return nil
        }
        guard let authFlowState = AuthFlowState.getAuthFlowStateWithHeaderData(flowStateData: bodyData, headerData: headerData) else {
            return nil
        }
        return authFlowState
    }
    
    /**
     Decode Auth flow state from JWT
     
     - parameter jwt: a JSON web token string
     
     - returns JWT decoded into a an Auth flow state object or nil if JWT is not a valid Newton Keycloak service token
     */
    public static func decodeAuthFlowState(jwtToken jwt: String) -> AuthFlowState? {
        return decodeAuthFlowState(jwtToken: jwt, headerData: nil)
    }
    
    /**
     Check if given JWT is expired
     
     - parameter jwt: a JSON web token string
     
     - returns true if jwt is expired
     */
    public static func jwtExpired(jwt: String) -> Bool {
        let decoded = decode(jwtToken: jwt)
        guard let exp = decoded["exp"] as? TimeInterval else {
            return false
        }
        let expDate = Date(timeIntervalSince1970: exp)
        return expDate < Date()
    }

    private static func base64UrlDecode(_ value: String) -> Data? {
        var base64 = value
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        let length = Double(base64.lengthOfBytes(using: String.Encoding.utf8))
        let requiredLength = 4 * ceil(length / 4.0)
        let paddingLength = requiredLength - length
        if paddingLength > 0 {
            let padding = "".padding(toLength: Int(paddingLength), withPad: "=", startingAt: 0)
                base64 = base64 + padding
            }
        return Data(base64Encoded: base64, options: .ignoreUnknownCharacters)
    }

    private static func decodeJWTPart(_ value: String) -> [String: Any]? {
        guard
            let bodyData = base64UrlDecode(value),
            let json = try? JSONSerialization.jsonObject(with: bodyData, options: []),
            let payload = json as? [String: Any]
        else {
            return nil
        }
        return payload
    }
}
