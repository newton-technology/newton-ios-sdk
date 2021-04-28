//
//  AuthHttpController.swift
//  
//
//  Created by Mihail Kuznetsov on 28.04.2021.
//

import Foundation
import Alamofire

public class AuthHttpController {
    
    static let instance = AuthHttpController()
    
    public static let defaultRetryCount = 5
    public static let defaultRetryDelay = 2
    private static let defaultTimeout = 30
    
    private let sessionManager: Session
    
    public init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = TimeInterval(AuthHttpController.defaultTimeout)
        sessionManager = Session(configuration: configuration)
    }
    
    public func request(
        url: URL,
        method: HTTPMethod,
        headers: [String: String]? = nil,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = JSONEncoding.default,
        retryCount: Int = defaultRetryCount,
        retryDelay: Int = defaultRetryDelay,
        onSuccess: ((_ responseCode: Int, _ responseData: AuthResult?) -> Void)? = nil,
        onError errorHandler: ((_ error: Error, _ responseCode: Int?, _ responseData: AuthError?) -> Void)? = nil
    )
    {
        sessionManager
            .request(
                url,
                method: .post,
                parameters: parameters,
                headers: HTTPHeaders(headers ?? [:])
            )
            .validate()
            .responseJSON { (data) in
                let responseCode = data.response?.statusCode

                if let error = data.error {
                    guard
                        let data = data.data,
                        let responseData = try? JSONDecoder().decode(AuthError.self, from: data)
                    else {
                        self.onError(
                            error: error,
                            responseCode: responseCode,
                            responseData: AuthError(error: .unknownError, errorDescription: nil),
                            onError: errorHandler)
                        return
                    }

                    self.onError(
                        error: error,
                        responseCode: responseCode,
                        responseData: responseData,
                        onError: errorHandler
                    )
                    return
                }

                guard let statusCode = responseCode else {
                    self.onError(
                        error: "missing status code for response" as! Error,
                        responseCode: responseCode,
                        responseData: nil,
                        onError: errorHandler
                    )
                    return
                }
                
                let authResult = try? JSONDecoder().decode(AuthResult.self, from: data.value as! Data)

                guard let successHandler = onSuccess else { return }
                successHandler(statusCode, authResult)
            }
    }
    
    private func onError(
        error: Error,
        responseCode: Int?,
        responseData: AuthError?,
        onError: ((_ error: Error, _ responseCode: Int?, _ responseData: AuthError?) -> Void)? = nil) {
        guard let errorHandler = onError else {
            // TODO Logging
            return
        }
        errorHandler(error, responseCode, responseData)
    }
    
}

