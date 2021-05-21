//
//  AuthServiceRealmCompletionHandler.swift
//  
//
//  Created by Mihail Kuznetsov on 21.05.2021.
//

import Foundation

public protocol AuthCompletionHandler: AnyObject {
    func onSuccess(authResult: AuthResult, authFlowState: AuthFlowState?)
    func onError(error: AuthError)
}
