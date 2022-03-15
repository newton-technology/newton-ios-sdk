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
    
    private static let defaultRetryCount = 5
    private static let defaultRetryDelay = 2
    private static let defaultTimeout = 30
    
    private let sessionManager: Session
    
    class AuthRequestInterceptor: RequestInterceptor {

        private let retryCount: Int, retryDelay: Int

        init(retryCount: Int = defaultRetryCount, retryDelay: Int = defaultRetryDelay)
        {
            self.retryCount = retryCount
            self.retryDelay = retryDelay
        }

        public func retry(
            _ request: Request,
            for session: Session,
            dueTo error: Error,
            completion: @escaping (RetryResult) -> Void)
        {
            let response = request.task?.response as? HTTPURLResponse

            if let statusCode = response?.statusCode, (400...500).contains(statusCode) {
                completion(.doNotRetry)
                return
            }

            if request.retryCount < retryCount {
                completion(.retryWithDelay(TimeInterval(retryDelay)))
            } else {
                completion(.doNotRetry)
            }
        }
    }
    
    private init() {
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
        onSuccess: ((_ responseCode: Int, _ responseData: AuthResult?, _ headerData: [AnyHashable: Any]?) -> Void)? = nil,
        onError errorHandler: ((_ error: Error, _ responseCode: Int?, _ responseData: AuthError?) -> Void)? = nil
    )
    {
        sessionManager
            .request(
                url,
                method: method,
                parameters: parameters,
                headers: HTTPHeaders(headers ?? [:]),
                interceptor: AuthRequestInterceptor(retryCount: AuthHttpController.defaultRetryCount, retryDelay: AuthHttpController.defaultRetryDelay)
            )
            .validate()
            .responseJSON { (data) in
                let responseCode = data.response?.statusCode

                if let error = data.error {
                    if (error.responseCode == 500) {
                        self.onError(
                            error: error,
                            responseCode: responseCode,
                            responseData: AuthError(
                                error: .serverError,
                                errorDescription: "Error: \(data.response?.description ?? "Server error")",
                                otpChecksLeft: nil,
                                otpSendsLeft: nil
                            ),
                            onError: errorHandler)
                        return
                    }
                    guard
                        let errorData = data.data,
                        let responseData = try? JSONDecoder().decode(AuthError.self, from: errorData)
                    else {
                        self.onError(
                            error: error,
                            responseCode: responseCode,
                            responseData: AuthError(
                                error: .unknownError,
                                errorDescription: "Error: \(data.response?.description ?? "Unknown error")",
                                otpChecksLeft: nil,
                                otpSendsLeft: nil
                            ),
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
                guard let successHandler = onSuccess else { return }
                guard
                    let result = AuthResult.getAuthResultWithHeadersData(resultData: data.data, headerData: data.response?.headers.dictionary)
                else {
                    successHandler(statusCode, nil, nil)
                    return
                }
                successHandler(statusCode, result, data.response?.headers.dictionary)
            }
    }
    
    private func onError(
        error: Error,
        responseCode: Int?,
        responseData: AuthError?,
        onError: ((_ error: Error, _ responseCode: Int?, _ responseData: AuthError?) -> Void)? = nil) {
        guard let errorHandler = onError else {
            //TODO: Logging
            return
        }
        errorHandler(error, responseCode, responseData)
    }
    
}
