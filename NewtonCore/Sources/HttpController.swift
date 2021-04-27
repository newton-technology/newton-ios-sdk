//
//  HttpController.swift
//  
//
//  Created by Mihail Kuznetsov on 26.04.2021.
//



import Foundation
import Alamofire

public class HttpController {
    
    public static let defaultRetryCount = 5
    public static let defaultRetryDelay = 2
    private static let defaultTimeout = 30
    
    public init() {
        //
    }
    
    public func request(
        url: URL,
        method: HTTPMethod,
        headers: [String: String]? = nil,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = JSONEncoding.default,
        retryCount: Int = defaultRetryCount,
        retryDelay: Int = defaultRetryDelay,
        onSuccess: ((_ responseCode: Int, _ responseData: [String: Any?]?) -> Void)? = nil,
        onError errorHandler: ((_ error: Error, _ responseCode: Int?, _ responseData: [String: Any?]?) -> Void)? = nil
    )
    {
        AF
            .request(
                url,
                method: method,
                parameters: parameters,
                headers: HTTPHeaders(headers ?? [:])
            )
            .validate()
            .responseJSON { (data) in
                let responseCode = data.response?.statusCode

                if let error = data.error {
                    guard
                        let data = data.data,
                        let responseData = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any?]
                    else {
                        self.onError(
                            error: error,
                            responseCode: responseCode,
                            responseData: nil,
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
                    return
                }
                let responseDictionary = data.value as? [String: Any] ?? [:]

                guard let successHandler = onSuccess else { return }
                successHandler(statusCode, responseDictionary)
            }
    }
    
    private func onError(
        error: Error,
        responseCode: Int?,
        responseData: [String: Any?]?,
        onError: ((_ error: Error, _ responseCode: Int?, _ responseData: [String: Any?]?) -> Void)? = nil) {
        guard let errorHandler = onError else {
            // TODO Logging
            return
        }
        errorHandler(error, responseCode, responseData)
    }
    
}
